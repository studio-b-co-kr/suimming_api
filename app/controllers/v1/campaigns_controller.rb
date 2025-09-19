class V1::CampaignsController < ApplicationController
  skip_before_action :authenticate_request!, only: [:index, :show, :my_summary]

  def index
    campaigns = Campaign.where.not(status: "draft").order(created_at: :desc)
    render json: { campaigns: campaigns.as_json(only: [
      :id,
      :title,
      :status,
      :start_time,
      :end_time,
      :supported_exchanges,
      :token_symbol,
      :reward_total_quantity,
      :reward_symbol,
      :reward_distribution_method,
      :reward_allocation_method,
      :reward_max_participants
    ])}
  end

  def show
    campaign = Campaign.find(params[:id])

    render json: { campaign: campaign.as_json(only: [
      :id,
      :title,
      :status,
      :start_time,
      :end_time,
      :supported_exchanges,
      :token_symbol,
      :reward_total_quantity,
      :reward_symbol,
      :reward_distribution_method,
      :reward_allocation_method,
      :reward_max_participants
    ])}
  end

  def my_open_orders

  end

  def my_executed_orders
    
  end

  def my_summary
    campaign = Campaign.find(params[:id])

    campaign_participants = CampaignParticipant.where(campaign_id: params[:id]).order(trading_volume: :desc)
    my_campaign_participant = campaign_participants.find_by(user_id: 2)

    if my_campaign_participant.present?
      my_reward_rank = campaign_participants.find_index(my_campaign_participant) + 1
      my_reward_eligibility = my_reward_rank <= campaign.reward_max_participants 
      trading_volume = my_campaign_participant.trading_volume
    else
      my_reward_rank = nil
      my_reward_eligibility = false
      trading_volume = 0
    end

    # Mock user data based on campaign and user
    my_summary = {
      campaign_id: campaign.id,
      user_id: 2,
      reward_rank: my_reward_rank,
      reward_eligibility: my_reward_eligibility,
      trading_volume: trading_volume


      # executedOrders: Array.new(rand(5..15)) do
      #   {
      #     id: rand(10000..99999),
      #     pair: "BLUEKRW",
      #     type: ["buy", "sell"].sample,
      #     amount: rand(1..100).round(6),
      #     price: rand(2400..2600).round(2),
      #     total: rand(2400..260000).round(2),
      #     fee: rand(1..10).round(4),
      #     status: "completed",
      #     executed_at: (Time.current - rand(1..168).hours).iso8601
      #   }
      # end,
      # outstandingOrders: [
      #   {
      #     id: rand(1000..9999),
      #     pair: "BLUEKRW",
      #     type: "buy",
      #     amount: rand(10..100).round(2),
      #     price: rand(2400..2500).round(2),
      #     status: "pending",
      #     created_at: (Time.current - rand(1..24).hours).iso8601
      #   },
      #   {
      #     id: rand(1000..9999),
      #     pair: "BLUEKRW",
      #     type: "sell",
      #     amount: rand(5..50).round(2),
      #     price: rand(2500..2600).round(2),
      #     status: "pending",
      #     created_at: (Time.current - rand(1..12).hours).iso8601
      #   }
      # ],
    }

    render json: { my_summary: my_summary }
  end
end
