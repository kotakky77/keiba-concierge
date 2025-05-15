class Participant < ApplicationRecord
  belongs_to :event
  has_many :attendances, dependent: :destroy
  has_many :date_options, through: :attendances
  has_many :items, dependent: :nullify
  has_many :expenses, foreign_key: :payer_id, dependent: :nullify

  validates :name, presence: true
end
