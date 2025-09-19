class CreateCampaignOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :campaign_orders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :exchange_setting, null: false, foreign_key: true
      t.references :campaign, null: false, foreign_key: true

      t.string :exchange, null: false
      t.string :symbol, null: false, comment: "거래쌍 예: BTC/USDT"
      t.string :order_id, comment: "거래소에서 부여하는 주문 ID"
      t.string :order_type, comment: "limit, market, etc"
      t.string :side, comment: "buy or sell"

      t.decimal :price, precision: 20, scale: 10
      t.decimal :quantity, precision: 20, scale: 10

      t.decimal :filled_price, precision: 20, scale: 10
      t.decimal :filled_quantity, precision: 20, scale: 10
      t.datetime :filled_at
      t.datetime :cancelled_at
      
      t.json :fees, default: []

      t.json :trades, default: []

      t.string :status, null: false, default: "pending", comment: "pending, cancelled, filled"
      t.datetime :completed_on

      t.timestamps
    end

    add_index :campaign_orders, :order_id
    add_index :campaign_orders, [:user_id, :campaign_id]
    add_index :campaign_orders, [:exchange, :symbol]
  end
end
