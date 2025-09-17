class V1::DemoController < ApplicationController
  include Login
  skip_before_action :authenticate_request!, only: [:campaigns, :campaign, :user_data, :create_trade]

  # GET /v1/demo/campaigns
  def campaigns
    render json: {
      campaigns: [
        {
          id: 1,
          name: "Summer Trading Challenge",
          start_date_time: "2024-06-01T00:00:00Z",
          end_date_time: "2024-08-31T23:59:59Z",
          token: "BLUE",
          exchange: "Bithumb",
          status: "active",
          prize_structure: "top_10_percentage",
          rules: {
            min_trade_amount: 0.1,
            max_trades_per_day: 10,
            allowed_pairs: ["BLUEKRW"]
          },
          prize_pool: 10000,
          prize_pool_token: "BLUE",
          token_current_price: 2450.75,
          price_currency: "KRW"
        },
        {
          id: 2,
          name: "Whale Watcher",
          start_date_time: "2024-07-15T00:00:00Z",
          end_date_time: "2024-09-15T23:59:59Z",
          token: "BLUE",
          exchange: "Bithumb",
          status: "active",
          prize_structure: "fixed_rewards",
          rules: {
            min_trade_amount: 0.01,
            max_trades_per_day: 5,
            allowed_pairs: ["WBLUEKRW"]
          },
          prize_pool: 25000,
          prize_pool_token: "BLUE",
          token_current_price: 67500.25,
          price_currency: "KRW"
        },
        {
          id: 3,
          name: "Quick Flip Contest",
          start_date_time: "2024-05-01T00:00:00Z",
          end_date_time: "2024-05-31T23:59:59Z",
          token: "BLUE",
          exchange: "Bithumb",
          status: "completed",
          prize_structure: "winner_takes_all",
          rules: {
            min_trade_amount: 1,
            max_trades_per_day: 20,
            allowed_pairs: ["BLUEKRWC"]
          },
          prize_pool: 5000,
          prize_pool_token: "BLUE",
          token_current_price: 145.80,
          price_currency: "KRW"
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
        start_date_time: "2024-06-01T00:00:00Z",
        end_date_time: "2024-08-31T23:59:59Z",
        token: "BLUE",
        exchange: "Bithumb",
        status: "active",
        prize_structure: "top_10_percentage",
        rules: {
          min_trade_amount: 0.1,
          max_trades_per_day: 10,
          allowed_pairs: ["BLUEKRW"],
          trading_hours: "24/7",
          minimum_hold_time: "1 hour"
        },
        prize_pool: 10000,
        prize_pool_token: "BLUE",
        token_current_price: 2450.75,
        price_currency: "KRW",
        leaderboard: [
          { rank: 1, wallet: "0x1234...5678", profit: 2500, trades: 45 },
          { rank: 2, wallet: "0x8765...4321", profit: 2200, trades: 38 },
          { rank: 3, wallet: "0x9999...1111", profit: 1800, trades: 52 }
        ]
      },
      2 => {
        id: 2,
        name: "Whale Watcher",
        start_date_time: "2024-07-15T00:00:00Z",
        end_date_time: "2024-09-15T23:59:59Z",
        token: "BLUEC",
        exchange: "Bithumb",
        status: "active",
        prize_structure: "fixed_rewards",
        rules: {
          min_trade_amount: 0.01,
          max_trades_per_day: 5,
          allowed_pairs: ["BLUEKRW"],
          trading_hours: "24/7",
          minimum_hold_time: "4 hours"
        },
        prize_pool: 25000,
        prize_pool_token: "BLUE",
        token_current_price: 67500.25,
        price_currency: "KRW",
        leaderboard: [
          { rank: 1, wallet: "0xaaaa...bbbb", profit: 5500, trades: 12 },
          { rank: 2, wallet: "0xcccc...dddd", profit: 4800, trades: 8 },
          { rank: 3, wallet: "0xeeee...ffff", profit: 3900, trades: 15 }
        ]
      },
      3 => {
        id: 3,
        name: "Quick Contest",
        start_date_time: "2024-05-01T00:00:00Z",
        end_date_time: "2024-05-31T23:59:59Z",
        token: "BLUE",
        exchange: "Bithumb",
        status: "completed",
        prize_structure: "winner_takes_all",
        rules: {
          min_trade_amount: 1,
          max_trades_per_day: 20,
          allowed_pairs: ["BLUEKRW"],
          trading_hours: "24/7",
          minimum_hold_time: "30 minutes"
        },
        prize_pool: 5000,
        prize_pool_token: "BLUE",
        token_current_price: 145.80,
        price_currency: "KRW",
        leaderboard: [
          { rank: 1, wallet: "0xfff...aaa", profit: 1250, trades: 89 },
          { rank: 2, wallet: "0xbbb...ccc", profit: 980, trades: 76 },
          { rank: 3, wallet: "0xddd...eee", profit: 750, trades: 65 }
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

  # GET /v1/demo/campaigns/:campaign_id/user_data
  def user_data
    campaign_id = params[:campaign_id].to_i

    # Try to get user_id from params or current_user safely
    user_id = params[:user_id]
    if user_id.nil?
      begin
        user_id = current_user&.id
      rescue
        user_id = nil
      end
    end

    if user_id.nil?
      render json: { error: 'User ID required' }, status: :bad_request
      return
    end

    # Get user wallet safely
    user_wallet = begin
      current_user&.wallet_address
    rescue
      nil
    end || "0x#{user_id}...#{rand(1000..9999)}"

    # Mock user data based on campaign and user
    user_data = {
      campaign_id: campaign_id,
      user_id: user_id,
      eligibilityForPrizePool: true,
      totalExecutedTradeVol: rand(50000..500000).round(2),
      outstandingOrders: [
        {
          id: rand(1000..9999),
          pair: "BLUEKRW",
          type: "buy",
          amount: rand(10..100).round(2),
          price: rand(2400..2500).round(2),
          status: "pending",
          created_at: (Time.current - rand(1..24).hours).iso8601
        },
        {
          id: rand(1000..9999),
          pair: "BLUEKRW",
          type: "sell",
          amount: rand(5..50).round(2),
          price: rand(2500..2600).round(2),
          status: "pending",
          created_at: (Time.current - rand(1..12).hours).iso8601
        }
      ],
      prize_pool_rank: rand(1..100),
      price_pool_rank_listing: Array.new(10) do |i|
        {
          rank: i + 1,
          user_id: i == 0 ? user_id : rand(1000..9999),
          wallet: i == 0 ? user_wallet : "0x#{rand(1000..9999)}...#{rand(1000..9999)}",
          profit: rand(1000..10000).round(2),
          trades: rand(10..100),
          volume: rand(50000..500000).round(2)
        }
      end,
      executedOrders: Array.new(rand(5..15)) do
        {
          id: rand(10000..99999),
          pair: "BLUEKRW",
          type: ["buy", "sell"].sample,
          amount: rand(1..100).round(6),
          price: rand(2400..2600).round(2),
          total: rand(2400..260000).round(2),
          fee: rand(1..10).round(4),
          status: "completed",
          executed_at: (Time.current - rand(1..168).hours).iso8601
        }
      end
    }

    render json: { user_data: user_data }
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