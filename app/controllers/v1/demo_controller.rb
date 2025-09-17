class V1::DemoController < ApplicationController
  include Login
  skip_before_action :authenticate_request!, only: [:campaigns, :campaign]

  # GET /v1/demo/campaigns
  def campaigns
    render json: {
      campaigns: [
        {
          id: 1,
          name: "Summer Trading Challenge",
          description: "Trade your way to the top this summer",
          start_date: "2024-06-01",
          end_date: "2024-08-31",
          status: "active",
          total_participants: 245,
          prize_pool: 10000
        },
        {
          id: 2,
          name: "Whale Watcher",
          description: "Track and follow the biggest moves",
          start_date: "2024-07-15",
          end_date: "2024-09-15",
          status: "active",
          total_participants: 189,
          prize_pool: 25000
        },
        {
          id: 3,
          name: "Quick Flip Contest",
          description: "Fast trades, quick profits",
          start_date: "2024-05-01",
          end_date: "2024-05-31",
          status: "completed",
          total_participants: 567,
          prize_pool: 5000
        }
      ]
    }
  end

  # GET /v1/demo/campaigns/:id
  def campaign
    campaign_id = params[:id].to_i

    campaigns_data = {
      1 => {
        id: 1,
        name: "Summer Trading Challenge",
        description: "Trade your way to the top this summer",
        start_date: "2024-06-01",
        end_date: "2024-08-31",
        status: "active",
        total_participants: 245,
        prize_pool: 10000,
        rules: {
          min_trade_amount: 100,
          max_trades_per_day: 10,
          allowed_tokens: ["ETH", "BTC", "USDC", "SOL"]
        },
        leaderboard: [
          { rank: 1, wallet: "0x1234...5678", profit: 2500, trades: 45 },
          { rank: 2, wallet: "0x8765...4321", profit: 2200, trades: 38 },
          { rank: 3, wallet: "0x9999...1111", profit: 1800, trades: 52 }
        ]
      },
      2 => {
        id: 2,
        name: "Whale Watcher",
        description: "Track and follow the biggest moves",
        start_date: "2024-07-15",
        end_date: "2024-09-15",
        status: "active",
        total_participants: 189,
        prize_pool: 25000,
        rules: {
          min_trade_amount: 1000,
          max_trades_per_day: 5,
          allowed_tokens: ["ETH", "BTC", "WETH"]
        },
        leaderboard: [
          { rank: 1, wallet: "0xaaaa...bbbb", profit: 5500, trades: 12 },
          { rank: 2, wallet: "0xcccc...dddd", profit: 4800, trades: 8 },
          { rank: 3, wallet: "0xeeee...ffff", profit: 3900, trades: 15 }
        ]
      }
    }

    campaign = campaigns_data[campaign_id]

    if campaign
      render json: { campaign: campaign }
    else
      render json: { error: 'Campaign not found' }, status: :not_found
    end
  end

  # POST /v1/demo/campaigns/:campaign_id/trades
  def create_trade
    if current_user
      campaign_id = params[:campaign_id]

      trade_data = {
        id: rand(10000..99999),
        campaign_id: campaign_id,
        user_id: current_user.id,
        wallet_address: current_user.wallet_address,
        token_in: trade_params[:token_in],
        token_out: trade_params[:token_out],
        amount_in: trade_params[:amount_in],
        amount_out: trade_params[:amount_out] || (trade_params[:amount_in].to_f * rand(0.95..1.05)).round(6),
        transaction_hash: "0x#{SecureRandom.hex(32)}",
        timestamp: Time.current,
        status: "completed"
      }

      render json: {
        success: true,
        trade: trade_data,
        message: "Trade recorded successfully"
      }
    else
      render json: { error: 'Not authenticated' }, status: :unauthorized
    end
  end

  private

  def trade_params
    params.permit(:token_in, :token_out, :amount_in, :amount_out)
  end
end