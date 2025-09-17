class CreateSsoIdentities < ActiveRecord::Migration[6.0]
  def change
    create_table :sso_identities do |t|
      t.bigint :user_id, null: false
      t.string :provider, null: false, default: ''
      t.string :uid, null: false, default: ''
      t.timestamps
    end

    add_index :sso_identities, :user_id
  end
end
