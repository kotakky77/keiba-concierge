class DateOption < ApplicationRecord
  belongs_to :event
  has_many :attendances, dependent: :destroy
  has_many :participants, through: :attendances
  
  validates :date, presence: true
end
