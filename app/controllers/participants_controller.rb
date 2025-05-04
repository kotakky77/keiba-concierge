class ParticipantsController < ApplicationController
  before_action :set_event

  def create
    @participant = @event.participants.build(name: params[:name])
    
    if @participant.save
      # 参加者作成と同時に日程オプションへの回答を保存
      if params[:attendance_form] && params[:attendance_form][:date_option_ids].present?
        # 共通コメント（全候補日に適用）
        common_comment = params[:comment].presence

        params[:attendance_form][:date_option_ids].each do |date_option_id, status|
          date_option = @event.date_options.find_by(id: date_option_id)
          if date_option && status.present?
            # 候補日特有のコメントがあればそれを使用、なければ共通コメント
            date_option_comments = params[:attendance_form][:date_option_comments] || {}
            specific_comment = date_option_comments[date_option_id].presence
            comment = specific_comment || common_comment
            
            @participant.attendances.create(
              date_option: date_option,
              status: status,
              comment: comment
            )
          end
        end
      end
      
      redirect_to event_path(@event), notice: '出欠情報が登録されました'
    else
      redirect_to event_path(@event), alert: '出欠情報の登録に失敗しました'
    end
  end
  
  # 既存の回答を更新する
  def update_attendance
    @participant = @event.participants.find(params[:participant_id])
    
    if params[:attendance_form] && params[:attendance_form][:date_option_ids].present?
      # 共通コメントがあれば適用
      common_comment = params[:comment].presence
      
      # 各候補日に対する回答を処理
      params[:attendance_form][:date_option_ids].each do |date_option_id, status|
        date_option = @event.date_options.find_by(id: date_option_id)
        if date_option && status.present?
          # 候補日特有のコメントがあればそれを使用
          date_option_comments = params[:attendance_form][:date_option_comments] || {}
          specific_comment = date_option_comments[date_option_id].presence
          comment = specific_comment || common_comment
          
          # 既存の出欠情報を検索
          attendance = @participant.attendances.find_by(date_option_id: date_option.id)
          
          if attendance
            # 既存の出欠情報を更新
            attendance.update(status: status, comment: comment)
          else
            # 新規作成
            @participant.attendances.create(
              date_option: date_option,
              status: status,
              comment: comment
            )
          end
        end
      end
      
      redirect_to event_path(@event), notice: '出欠情報が更新されました'
    else
      redirect_to event_path(@event), alert: '更新する出欠情報がありません'
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to event_path(@event), alert: '参加者が見つかりません'
  end
  
  # 参加者の出欠情報を取得するAPI
  def attendances
    @participant = @event.participants.find(params[:participant_id])
    attendances = @participant.attendances.includes(:date_option).map do |attendance|
      {
        id: attendance.id,
        date_option_id: attendance.date_option_id,
        status: attendance.status,
        comment: attendance.comment
      }
    end
    
    render json: { attendances: attendances }
  rescue ActiveRecord::RecordNotFound
    render json: { error: '参加者が見つかりません' }, status: :not_found
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'イベントが見つかりませんでした'
  end
end
