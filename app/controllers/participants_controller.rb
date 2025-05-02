class ParticipantsController < ApplicationController
  before_action :set_event

  def create
    @participant = @event.participants.build(participant_params)
    
    if @participant.save
      # 参加者作成と同時に日程オプションへの回答を保存
      if params[:attendance].present? && params[:attendance][:date_option_ids].present?
        params[:attendance][:date_option_ids].each do |date_option_id, status|
          date_option = @event.date_options.find_by(id: date_option_id)
          if date_option && status.present?
            @participant.attendances.create(
              date_option: date_option,
              status: status,
              comment: params[:attendance][:comment]
            )
          end
        end
      end
      
      redirect_to event_path(@event), notice: '参加者情報が登録されました'
    else
      redirect_to event_path(@event), alert: '参加者情報の登録に失敗しました'
    end
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'イベントが見つかりませんでした'
  end

  def participant_params
    params.require(:participant).permit(:name)
  end
end
