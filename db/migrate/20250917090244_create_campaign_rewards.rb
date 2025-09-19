class CreateCampaignRewards < ActiveRecord::Migration[8.0]
  def change
    create_table :campaign_rewards do |t|
      t.references :campaign_participant_epoch, null: false, foreign_key: { to_table: :campaign_participant_epochs }
      t.decimal :reward_amount, precision: 20, scale: 8, null: false
      t.string :status, default: "pending"
      t.datetime :distributed_at
      
      t.timestamps
    end
  end
end
