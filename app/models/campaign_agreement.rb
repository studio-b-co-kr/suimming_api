class CampaignAgreement < ApplicationRecord
  belongs_to :campaign

  enum :status, {
    draft: "draft",
    pending_signature: "pending_signature",
    active: "active",
    terminated: "terminated"
  }

  validates :operator_fee, numericality: { greater_than_or_equal_to: 0 }

  def fully_signed?
    foundation_signed && operator_signed
  end

  def activate!
    update!(status: "active") if fully_signed? && foundation_transferred
  end
  
end
