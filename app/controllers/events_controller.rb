class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update]

  def index
    @events = Event.order(created_at: :desc)
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
end
