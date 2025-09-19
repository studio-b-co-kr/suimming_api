class Campaign < ApplicationRecord
  belongs_to :user
  has_many :participants, class_name: "CampaignParticipant", dependent: :destroy

  enum :reward_distribution_method, {
    one_time: "one_time",
    daily: "daily",
    weekly: "weekly",
    custom_interval: "custom_interval"
  }

  enum :reward_allocation_method, {
    proportional: "proportional",
    equal: "equal"
  }

  enum :status, {
    draft: "draft",
    active: "active",
    completed: "completed",
    cancelled: "cancelled"
  }
    
  before_save :save_epoch_infomation
    
  def save_epoch_infomation
    self.reward_per_epoch = reward_total_quantity.to_d / reward_num_of_epochs
    total_seconds = (end_at - start_at).to_f
    self.reward_epoch_interval_minutes = (total_seconds / reward_num_of_epochs / 60).ceil
  end
end
