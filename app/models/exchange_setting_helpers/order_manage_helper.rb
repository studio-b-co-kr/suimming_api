module ExchangeSettingHelpers::OrderManageHelper
  extend self

  def create_campaign_order(
    campaign_id:, symbol:, order_price:, side:, order_quantity:, order_type:, make_only: false)
    order_id = ''
    case self.exchange
    when 'bithumb'
      body = private_client.formatted_create_order(symbol: symbol, side: side, price: order_price, quantity: order_quantity, order_type: order_type, make_only: make_only)
      order_id = body['order_id']
    else
      raise "Missing exchange create campaign order #{exchange}"
    end

    raise "Order Manage Helper Missing order id #{exchange_symbol} #{exchange}" if order_id.blank?

    created_order = CampaignOrder.create!(
      user_id: self.user_id,
      exchange_setting_id: self.id,
      campaign_id: campaign_id,
      exchange: self.exchange,
      symbol: symbol,
      order_id: order_id,
      order_type: order_type,
      side: side,
      price: order_price,
      quantity: order_quantity,
      status: 'pending'
    )
    created_order
  end

  def update_campaign_order(campaign_order)
    # update common columns
    order_data = private_client.formatted_order(campaign_order.exchange_symbol, campaign_order.exchange_uuid)
    if order_data && order_data.present?
      Rails.logger.debug "order received update #{campaign_order.id}"
      campaign_order.update!(
        filled_quantity: order_data['filled_quantity'],
        filled_price: order_data['filled_price'],
        filled_at: order_data['filled_at'],
        fees: order_data['fees'],
        status: order_data['status'],
        completed_on: order_data['completed_on'],
        trades: order_data['trades']
      )
      if campaign_order.cancelled? && campaign_order.cancelled_at.nil?
        campaign_order.cancelled_at = Time.current 
      else
        campaign_order.cancelled_at = nil
      end 
      campaign_order.save
    else
      Rails.logger.error "#{exchange}: couldnt find in api order_id: #{campaign_order.order_id}"
    end
    campaign_order
  end

  def cancel_campaign_order(campaign_order)
    case exchange
    when 'bithumb'
      private_client.cancel_order(order_id: campaign_order.order_id)
      campaign_order.update!(cancelled_at: Time.current)
      # bithumb 은 cancel 된 주문을 조회했을 때 취소시간을 주지 않는다. 취소요청할 때 취소 요청 시간을 저장.
    else
      raise "Missing exchange cancel campaign order #{exchange}"
    end
  end

end
