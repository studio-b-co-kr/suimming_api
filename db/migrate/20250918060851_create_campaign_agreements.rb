class CreateCampaignAgreements < ActiveRecord::Migration[8.0]
  def change
    create_table :campaign_agreements do |t|
      t.references :campaign, null: false, foreign_key: true

      t.boolean :foundation_signed, default: false
      t.boolean :operator_signed, default: false

      t.boolean :foundation_transferred, default: false
      t.datetime :foundation_transferred_at

      t.decimal :operator_fee, precision: 20, scale: 8, default: 0

      t.jsonb :contract_terms, default: {}
      t.text :contract_text

      t.string :status, default: "draft", comment: "draft, pending_signature, active, terminated"
      
      t.timestamps
    end
  end
end
