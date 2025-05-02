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
    calendar_data = Rails.cache.fetch(cache_key, expires_in: 24.hours) do
      begin
        # ローカルのiCalendarファイルを読み込む
        kaisai_file_path = Rails.root.join("jradata", year.to_s, "jrakaisai#{year}.ics")
        race_file_path = Rails.root.join("jradata", year.to_s, "jrarace#{year}.ics")
        
        events = []
        
        # 開催情報ファイルの読み込み
        if File.exist?(kaisai_file_path)
          ical_data = File.read(kaisai_file_path)
          kaisai_events = parse_icalendar(ical_data)
          events.concat(kaisai_events) if kaisai_events
        end
        
        # レース情報ファイルの読み込み
        if File.exist?(race_file_path)
          ical_data = File.read(race_file_path)
          race_events = parse_icalendar(ical_data)
          events.concat(race_events) if race_events
        end
        
        events.empty? ? nil : events
      rescue => e
        Rails.logger.error("レーシングカレンダー読み込みエラー: #{e.message}")
        nil
      end
    end
    
    calendar_data
  end
  
  def parse_icalendar(ical_data)
    begin
      calendars = Icalendar::Calendar.parse(ical_data)
      calendar = calendars.first
      
      events = []
      calendar&.events&.each do |event|
        # レースイベントの情報を整形
        events << {
          summary: event.summary.to_s,
          description: event.description.to_s,
          location: event.location.to_s,
          start_date: event.dtstart.to_date,
          end_date: event.dtend.to_date
        }
      end
      
      events
    rescue => e
      Rails.logger.error("iCalendarパースエラー: #{e.message}")
      nil
    end
  end
end
