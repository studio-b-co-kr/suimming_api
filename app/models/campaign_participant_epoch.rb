class CampaignParticipantEpoch < ApplicationRecord
    belongs_to :campaign_participant
    has_one :reward, class_name: "CampaignReward", dependent: :destroy
end
