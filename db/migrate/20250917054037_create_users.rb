class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :wallet_address, null: false, default: ""
      t.string :wallet_type, null: false, default: ""
      t.jsonb  :meta, default: {}

      t.timestamps
    end

    add_index :users, :wallet_address, unique: true
  end
end
