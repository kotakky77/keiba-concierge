class Expense < ApplicationRecord
  belongs_to :event
  belongs_to :payer, class_name: 'Participant'
  
  validates :name, presence: true
  validates :amount, numericality: { only_integer: true, greater_than: 0 }
  
  # 精算状況の初期値を設定
  after_initialize :set_default_values, if: :new_record?
  
  private
  
  def set_default_values
    self.paid_status ||= false
  end
end
