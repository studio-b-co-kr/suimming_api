class CampaignOrderSerializer < ActiveModel::Serializer
  attributes :id, :campaign_id, :exchange, :symbol, :order_id, :order_type,
             :side, :price, :quantity, :filled_price, :filled_quantity,
             :filled_at, :cancelled_at, :status, :created_at,
             :fee_amount, :fee_currency, :order_value, :filled_value

  def order_value
    object.price * object.quantity
  end

  def filled_value
    if object.filled_price.present? && object.filled_quantity.present?
      object.filled_price * object.filled_quantity
    else
      0
    end
  end

  def fee_amount
    object.fees[0].present? ? object.fees[0]["fee"] : 0
  end

  def fee_currency
    object.fees[0].present? ? object.fees[0]["fee_coin"] : ""
  end
end
