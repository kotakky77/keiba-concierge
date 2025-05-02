class Attendance < ApplicationRecord
  belongs_to :participant
  belongs_to :date_option
  
  validates :status, presence: true, inclusion: { in: %w(yes maybe no) }
end
