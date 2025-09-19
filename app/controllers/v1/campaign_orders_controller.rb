class V1::CampaignOrdersController < ApplicationController
require "securerandom"

  def create
    my_exchange_setting = ExchangeSetting.find_by(user_id: current_user.id)
    created_order = CampaignOrder.new(
      user_id: current_user.id,
      exchange_setting_id: my_exchange_setting.id,
      campaign_id: campaign_order_params[:campaign_id],
      exchange: campaign_order_params[:exchange],
      symbol: campaign_order_params[:symbol],
      order_type: campaign_order_params[:order_type],
      side: campaign_order_params[:side],
      price: campaign_order_params[:order_price],
      quantity: campaign_order_params[:order_quantity],
      status: 'pending'
    )
    created_order.order_id = SecureRandom.uuid

    created_order.save

    render json: {
      campaign_order: created_order
    }
  end

  def cancel
  end

  def batch_update
  end

  def update
  end

  private

  def campaign_order_params
    params.require(:campaign_order).permit(:campaign_id, :exchange, :symbol, :order_type, :side, :order_price, :order_quantity)
  end

end
