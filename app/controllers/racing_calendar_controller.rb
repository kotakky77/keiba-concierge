class RacingCalendarController < ApplicationController
  require 'net/http'
  require 'uri'
  require 'icalendar'
  
  def index
    @year = params[:year] || Date.today.year
    @month = params[:month] || Date.today.month
    
    @calendar_data = fetch_racing_calendar(@year)
    
    if @calendar_data.nil?
      flash.now[:alert] = 'レーシングカレンダーの取得に失敗しました'
      @calendar_data = []
    end
  end
  
  private
  
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
  
  def parse_icalendar(ical_data, source_type = nil)
    begin
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
