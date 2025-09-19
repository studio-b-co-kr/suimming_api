class ExchangeSetting < ApplicationRecord
  belongs_to :user
  has_many :campaign_orders, dependent: :destroy

  validates :exchange, :access_key, :secret_key, presence: true
end
