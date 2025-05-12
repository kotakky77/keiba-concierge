class AttendancesController < ApplicationController
  def create
    @participant = Participant.find(params[:attendance][:participant_id])
    @date_option = DateOption.find(params[:attendance][:date_option_id])

    @attendance = Attendance.new(
      participant: @participant,
      date_option: @date_option,
      status: params[:attendance][:status],
      comment: params[:attendance][:comment]
    )

    if @attendance.save
      redirect_to event_path(@date_option.event), notice: "出欠情報が登録されました"
    else
      redirect_to event_path(@date_option.event), alert: "出欠情報の登録に失敗しました"
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "情報が見つかりませんでした"
  end

  def update
    @attendance = Attendance.find(params[:id])

    if @attendance.update(attendance_params)
      redirect_to event_path(@attendance.date_option.event), notice: "出欠情報が更新されました"
    else
      redirect_to event_path(@attendance.date_option.event), alert: "出欠情報の更新に失敗しました"
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "情報が見つかりませんでした"
  end

  private

  def attendance_params
    params.require(:attendance).permit(:status, :comment)
  end
end
