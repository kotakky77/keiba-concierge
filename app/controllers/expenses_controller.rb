class ExpensesController < ApplicationController
  before_action :set_event
  before_action :set_expense, only: [:update, :destroy]

  def create
    @expense = @event.expenses.build(expense_params)
    
    if @expense.save
      redirect_to event_path(@event), notice: '費用情報が登録されました'
    else
      redirect_to event_path(@event), alert: '費用情報の登録に失敗しました'
    end
  end

  def update
    if @expense.update(expense_params)
      redirect_to event_path(@event), notice: '費用情報が更新されました'
    else
      redirect_to event_path(@event), alert: '費用情報の更新に失敗しました'
    end
  end

  def destroy
    @expense.destroy
    redirect_to event_path(@event), notice: '費用情報が削除されました'
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'イベントが見つかりませんでした'
  end

  def set_expense
    @expense = @event.expenses.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to event_path(@event), alert: '費用情報が見つかりませんでした'
  end

  def expense_params
    params.require(:expense).permit(:name, :amount, :payer_id, :paid_status)
  end
end
