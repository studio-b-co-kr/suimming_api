class CreateCampaignParticipants < ActiveRecord::Migration[8.0]
  def change
    create_table :campaign_participants do |t|
      t.references :campaign, null: false, foreign_key: true
      t.bigint :user_id, null: false
      t.decimal :trading_volume, precision: 20, scale: 8, default: 0, comment: "캠페인에서의 총 거래량"
      t.jsonb :meta, default: {}

      t.timestamps
    end
    
    add_index :campaign_participants, :user_id
    add_index :campaign_participants, [:campaign_id, :user_id], unique: true
  end
end
