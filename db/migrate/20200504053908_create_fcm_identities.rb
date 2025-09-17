class CreateFcmIdentities < ActiveRecord::Migration[6.0]
  def change
    create_table :fcm_identities do |t|
      t.bigint :user_id, null: false
      t.string :token, null: false, default: ''
      t.string :device_id, null: false, default: ''
      t.boolean :active, default: true
      t.timestamps
    end

    add_index :fcm_identities, [:active, :user_id, :device_id]
  end
end
