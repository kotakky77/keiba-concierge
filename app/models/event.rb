class Event < ApplicationRecord
  has_many :date_options, dependent: :destroy
  has_many :participants, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :expenses, dependent: :destroy

  before_create :generate_url_hash

  validates :name, presence: true

  # URL用のユニークなハッシュを生成
  def generate_url_hash
    self.url_hash = SecureRandom.urlsafe_base64(16)
  end
end
