class CampaignOrder < ApplicationRecord
  belongs_to :user
  belongs_to :exchange_setting
  belongs_to :campaign

  enum :status, { 
    pending: "pending",
    cancelled: "cancelled",
    filled: "filled" 
  }

  validates :quantity, numericality: { greater_than: 0 }, allow_nil: true

  def order_value
    price * quantity
  end

  def filled_value
    filled_price * filled_quantity
  end

  def cancelled?
    status =~ /cancelled/
  end

end
