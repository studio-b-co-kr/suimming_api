class CreateVersions < ActiveRecord::Migration[6.0]
  def change
    create_table :versions do |t|
      t.string :latest_version, default: ''
      t.string :minimum_version, default: ''
      t.datetime :released_at, default: -> { 'CURRENT_TIMESTAMP' }
      t.timestamps
    end
  end
end
