class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update]

  def index
    @events = Event.order(created_at: :desc)
    
    # レーシングカレンダーの表示のための設定
    @year = params[:year] || Date.today.year
    @month = params[:month] || Date.today.month
    
    # RacingCalendarControllerからカレンダーデータ取得メソッドを流用
    @calendar_data = fetch_racing_calendar(@year)
    
    if @calendar_data.nil?
      flash.now[:alert] = 'レーシングカレンダーの取得に失敗しました'
      @calendar_data = []
    end
    
    # 全てのイベントを表示する場合は別のビューを使用
    render :events_list if params[:show_all]
  end

  def show
    # URLハッシュでアクセスされた場合の処理
    @event = Event.find_by(url_hash: params[:url_hash]) if params[:url_hash].present?
    
    # イベントが見つからない場合はリダイレクト
    redirect_to root_path, alert: 'イベントが見つかりませんでした。' and return unless @event

    @date_options = @event.date_options.order(:date)
    @participants = @event.participants
    @items = @event.items
    @expenses = @event.expenses
    @new_date_option = DateOption.new
    @new_participant = Participant.new
    @new_item = Item.new
    @new_expense = Expense.new
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)

    if @event.save
      # イベント作成成功時、日程候補もあれば保存
      if params[:date_options].present?
        params[:date_options].each do |date_option|
          @event.date_options.create(date: date_option) if date_option.present?
        end
      end
      
      redirect_to event_path(@event), notice: 'イベントが作成されました。イベントURLをシェアして参加者に共有してください。'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @event.update(event_params)
      redirect_to event_path(@event), notice: 'イベント情報が更新されました。'
    else
      render :edit
    end
  end

  private

  def set_event
    @event = Event.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'イベントが見つかりませんでした。'
  end

  def event_params
    params.require(:event).permit(:name, :location, :memo, :status, :confirmed_date)
  end
  
  # RacingCalendarControllerから移植したメソッド
  def fetch_racing_calendar(year)
    # キャッシュからデータを取得（24時間有効）
    cache_key = "racing_calendar_#{year}"
    # キャッシュを一時的に無効化して問題解決
    Rails.cache.delete(cache_key)
    calendar_data = Rails.cache.fetch(cache_key, expires_in: 24.hours) do
      begin
        # ローカルのiCalendarファイルを読み込む
        kaisai_file_path = Rails.root.join("jradata", year.to_s, "jrakaisai#{year}.ics")
        race_file_path = Rails.root.join("jradata", year.to_s, "jrarace#{year}.ics")
        
        events = []
        
        # 開催情報ファイルの読み込み (jrakaisai)
        if File.exist?(kaisai_file_path)
          ical_data = File.read(kaisai_file_path)
          kaisai_events = parse_icalendar(ical_data, 'kaisai')
          
          # 開催情報を直接イベントとして追加
          kaisai_events&.each do |event|
            events << event
          end
        end
        
        # レース情報ファイルの読み込み (jrarace)
        if File.exist?(race_file_path)
          ical_data = File.read(race_file_path)
          race_events = parse_icalendar(ical_data, 'race')
          
          # レース情報も直接イベントとして追加
          race_events&.each do |event|
            events << event
          end
        end
        
        events.empty? ? nil : events
      rescue => e
        Rails.logger.error("レーシングカレンダー読み込みエラー: #{e.message}")
        nil
      end
    end
    
    calendar_data
  end
  
  def parse_icalendar(ical_data, source_type)
    begin
      require 'icalendar'
      calendars = Icalendar::Calendar.parse(ical_data)
      calendar = calendars.first
      
      events = []
      calendar&.events&.each do |event|
        # DTENDは期間の翌日を表すため、実際の終了日は dtend - 1 day
        start_date = event.dtstart.to_date
        end_date = event.dtend.to_date - 1.day
        
        # 開催期間中の各日について個別のイベントを生成
        if source_type == 'kaisai'
          (start_date..end_date).each do |date|
            # 各日付に対して個別のイベントを作成
            events << {
              summary: event.summary.to_s,
              description: event.description.to_s,
              location: event.location.to_s,
              start_date: date,
              end_date: date,  # 単日のイベントとして扱う
              source_type: source_type,
              original_start_date: start_date,
              original_end_date: end_date
            }
          end
        else
          # レースイベント（jrarace）の場合は従来通りの処理
          events << {
            summary: event.summary.to_s,
            description: event.description.to_s,
            location: event.location.to_s,
            start_date: start_date,
            end_date: end_date,
            source_type: source_type
          }
        end
      end
      
      events
    rescue => e
      Rails.logger.error("iCalendarパースエラー: #{e.message}")
      nil
    end
  end
end
