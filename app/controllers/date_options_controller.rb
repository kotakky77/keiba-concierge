class DateOptionsController < ApplicationController
  before_action :set_event

  def create
    @date_option = @event.date_options.build(date_option_params)
    
    if @date_option.save
      redirect_to event_path(@event), notice: '候補日が追加されました'
    else
      redirect_to event_path(@event), alert: '候補日の追加に失敗しました'
    end
  end

  def destroy
    @date_option = @event.date_options.find(params[:id])
    @date_option.destroy
    
    redirect_to event_path(@event), notice: '候補日が削除されました'
  rescue ActiveRecord::RecordNotFound
    redirect_to event_path(@event), alert: '候補日が見つかりませんでした'
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'イベントが見つかりませんでした'
  end

  def date_option_params
    params.require(:date_option).permit(:date)
  end
end
