class ItemsController < ApplicationController
  before_action :set_event
  before_action :set_item, only: [:update, :destroy]

  def create
    @item = @event.items.build(item_params)
    
    if @item.save
      redirect_to event_path(@event), notice: '持ち物が追加されました'
    else
      redirect_to event_path(@event), alert: '持ち物の追加に失敗しました'
    end
  end

  def update
    if @item.update(item_params)
      redirect_to event_path(@event), notice: '持ち物情報が更新されました'
    else
      redirect_to event_path(@event), alert: '持ち物情報の更新に失敗しました'
    end
  end

  def destroy
    @item.destroy
    redirect_to event_path(@event), notice: '持ち物が削除されました'
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'イベントが見つかりませんでした'
  end

  def set_item
    @item = @event.items.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to event_path(@event), alert: '持ち物が見つかりませんでした'
  end

  def item_params
    params.require(:item).permit(:name, :quantity, :participant_id)
  end
end
