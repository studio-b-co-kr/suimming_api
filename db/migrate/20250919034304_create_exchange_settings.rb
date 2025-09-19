class CreateExchangeSettings < ActiveRecord::Migration[8.0]
  def change
    create_table :exchange_settings do |t|
      t.references :user, null: false, foreign_key: true
      t.string :exchange, null: false, comment: "거래소 이름 (bithumb, upbit 등)"
      t.string :access_key, null: false
      t.string :secret_key, null: false
      t.string :assigned_ip, comment: "할당된 IP"

      t.timestamps
    end
  end
end
