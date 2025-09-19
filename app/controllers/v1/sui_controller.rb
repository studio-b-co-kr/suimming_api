class V1::SuiController < ApplicationController
  skip_before_action :authenticate_request!

  def submit_transaction
    side = params[:side]
    price = params[:price]
    quantity = params[:quantity]
    symbol = params[:symbol]
    exchange = params[:exchange]
    filled_at = params[:filled_at]
    timestamp = params[:timestamp] || Time.now.to_i
    
    result = SubmitSuiTransaction.call(
      side: side,
      price: price,
      quantity: quantity,
      symbol: symbol,
      exchange: exchange,
      filled_at: filled_at,
      timestamp: timestamp
    )

    if result["digest"].present?
      render json: { message: 'Transaction submitted successfully', tx_digest: result["digest"] }, status: :ok
    else
      render json: { error: 'Transaction submission failed', details: result[:error] }, status: :unprocessable_entity
    end
  rescue => e
    render json: { error: 'Transaction submission failed', details: e.message }, status:
    
  end
end
