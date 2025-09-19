class CreateCampaigns < ActiveRecord::Migration[8.0]
  def change
    create_table :campaigns do |t|
      t.bigint :user_id, null: false, comment: "캠페인 생성자"
      
      t.string :title, null: false
      t.text :description
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      
      t.string :token_symbol, comment: "캠페인 참여/거래 기준 토큰 (BTC, USDT 등)"
      t.string :supported_exchanges, array: true, default: [], comment: "지원 거래소 목록"

      # 보상 관련
      t.decimal :reward_total_quantity, precision: 20, scale: 8, comment: "캠페인 전체 보상 토큰 수량"
      t.string :reward_symbol, comment: "보상 토큰 심볼 (BTC, USDT 등)"
      t.string :reward_distribution_method, default: "one_time", comment: "보상 지급 주기: daily, one_time, custom_interval 등"
      t.string :reward_allocation_method, default: "proportional", comment: "보상 분배 방식: proportional, equal"
      t.integer :reward_max_participants, comment: "보상을 받을 수 있는 최대 참여자 수"

      # 보상 Epoch 관련,
      t.integer :reward_num_of_epochs, default: 1, comment: "보상 지급 Epoch 수"
      t.decimal :reward_per_epoch, precision: 20, scale: 8, comment: "Epoch별 전체 보상 토큰 수량"
      t.integer :reward_epoch_interval_mintues, comment: "각 Epoch 간격 (분 단위)"

      # 상태 관리
      t.string :status, default: "draft", comment: "캠페인 상태: draft, active, completed, cancelled 등"

      t.jsonb :meta, default: {}, comment: "추가 옵션/설정 저장용 자유 JSON"


      t.timestamps
    end

    add_index :campaigns, :user_id
    add_index :campaigns, :token_symbol
    add_index :campaigns, :status
  end
end
