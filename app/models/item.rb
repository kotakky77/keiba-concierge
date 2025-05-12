class Item < ApplicationRecord
  belongs_to :event
  belongs_to :participant, optional: true

  validates :name, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
end
