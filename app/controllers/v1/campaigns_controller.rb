class V1::CampaignsController < ApplicationController
  skip_before_action :authenticate_request!, only: [:index, :show]

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
    if authenticate_request!
      campaign_orders = CampaignOrder.where(user_id: current_user.id, campaign_id: params[:id], completed_on: nil)
    else
      campaign_orders = []
    end
    render json: {
      my_open_orders: campaign_orders
    }
  end

  def my_executed_orders
    if authenticate_request!
      campaign_orders = CampaignOrder.where(user_id: current_user.id, campaign_id: params[:id]).where("filled_quantity > 0 and completed_on is not null")
    else
      campaign_orders = []
    end
    render json: {
      my_executed_orders: campaign_orders
    }
  end

  def my_summary
    campaign = Campaign.find(params[:id])
    if authenticate_request!
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

      my_summary = {
        campaign_id: campaign.id,
        user_id: current_user.id,
        reward_rank: my_reward_rank,
        reward_eligibility: my_reward_eligibility,
        trading_volume: trading_volume
      }
    else
      my_summary = {
        campaign_id: campaign.id,
        user_id: nil,
        reward_rank: nil,
        reward_eligibility: false,
        trading_volume: 0
      }
    end
    render json: { my_summary: my_summary }
  end
end
