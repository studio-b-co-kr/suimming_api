class AddTxIdToCampaignOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :campaign_orders, :tx_id, :string, comment: "onchain tx id"
  end
end
