class CampaignParticipant < ApplicationRecord
    belongs_to :campaign
    has_many :epochs, class_name: "CampaignParticipantEpoch", dependent: :destroy
end
