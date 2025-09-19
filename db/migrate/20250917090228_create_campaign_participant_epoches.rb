class CreateCampaignParticipantEpoches < ActiveRecord::Migration[8.0]
  def change
    create_table :campaign_participant_epochs do |t|
      t.references :campaign_participant, null: false, foreign_key: true
      t.integer :epoch_number, null: false
      t.decimal :trading_volume, precision: 20, scale: 8, default: 0, comment: "캠페인의 epoch에서 거래"

      t.timestamps
    end
    
    add_index :campaign_participant_epochs, [:campaign_participant_id, :epoch_number], unique: true, name: "index_cpe_on_participant_epoch"
  end
end
