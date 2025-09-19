# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_09_18_060851) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "campaign_agreements", force: :cascade do |t|
    t.bigint "campaign_id", null: false
    t.boolean "foundation_signed", default: false
    t.boolean "operator_signed", default: false
    t.boolean "foundation_transferred", default: false
    t.datetime "foundation_transferred_at"
    t.decimal "operator_fee", precision: 20, scale: 8, default: "0.0"
    t.jsonb "contract_terms", default: {}
    t.text "contract_text"
    t.string "status", default: "draft", comment: "draft, pending_signature, active, terminated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_campaign_agreements_on_campaign_id"
  end

  create_table "campaign_participant_epochs", force: :cascade do |t|
    t.bigint "campaign_participant_id", null: false
    t.integer "epoch_number", null: false
    t.decimal "trading_volume", precision: 20, scale: 8, default: "0.0", comment: "캠페인의 epoch에서 거래"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_participant_id", "epoch_number"], name: "index_cpe_on_participant_epoch", unique: true
    t.index ["campaign_participant_id"], name: "index_campaign_participant_epochs_on_campaign_participant_id"
  end

  create_table "campaign_participants", force: :cascade do |t|
    t.bigint "campaign_id", null: false
    t.bigint "user_id", null: false
    t.decimal "trading_volume", precision: 20, scale: 8, default: "0.0", comment: "캠페인에서의 총 거래량"
    t.jsonb "meta", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id", "user_id"], name: "index_campaign_participants_on_campaign_id_and_user_id", unique: true
    t.index ["campaign_id"], name: "index_campaign_participants_on_campaign_id"
    t.index ["user_id"], name: "index_campaign_participants_on_user_id"
  end

  create_table "campaign_rewards", force: :cascade do |t|
    t.bigint "campaign_participant_epoch_id", null: false
    t.decimal "reward_amount", precision: 20, scale: 8, null: false
    t.string "status", default: "pending"
    t.datetime "distributed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_participant_epoch_id"], name: "index_campaign_rewards_on_campaign_participant_epoch_id"
  end

  create_table "campaigns", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "캠페인 생성자"
    t.string "title", null: false
    t.text "description"
    t.datetime "start_time", null: false
    t.datetime "end_time", null: false
    t.string "token_symbol", comment: "캠페인 참여/거래 기준 토큰 (BTC, USDT 등)"
    t.string "supported_exchanges", default: [], comment: "지원 거래소 목록", array: true
    t.decimal "reward_total_quantity", precision: 20, scale: 8, comment: "캠페인 전체 보상 토큰 수량"
    t.string "reward_symbol", comment: "보상 토큰 심볼 (BTC, USDT 등)"
    t.string "reward_distribution_method", default: "one_time", comment: "보상 지급 주기: daily, one_time, custom_interval 등"
    t.string "reward_allocation_method", default: "proportional", comment: "보상 분배 방식: proportional, equal"
    t.integer "reward_max_participants", comment: "보상을 받을 수 있는 최대 참여자 수"
    t.integer "reward_num_of_epochs", default: 1, comment: "보상 지급 Epoch 수"
    t.decimal "reward_per_epoch", precision: 20, scale: 8, comment: "Epoch별 전체 보상 토큰 수량"
    t.integer "reward_epoch_interval_mintues", comment: "각 Epoch 간격 (분 단위)"
    t.string "status", default: "draft", comment: "캠페인 상태: draft, active, completed, cancelled 등"
    t.jsonb "meta", default: {}, comment: "추가 옵션/설정 저장용 자유 JSON"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status"], name: "index_campaigns_on_status"
    t.index ["token_symbol"], name: "index_campaigns_on_token_symbol"
    t.index ["user_id"], name: "index_campaigns_on_user_id"
  end

  create_table "jwt_denylists", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "jti", null: false
    t.datetime "exp", precision: nil, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jti"], name: "index_jwt_denylists_on_jti", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "wallet_address", default: "", null: false
    t.string "wallet_type", default: "", null: false
    t.jsonb "meta", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["wallet_address"], name: "index_users_on_wallet_address", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "latest_version", default: ""
    t.string "minimum_version", default: ""
    t.datetime "released_at", default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "campaign_agreements", "campaigns"
  add_foreign_key "campaign_participant_epochs", "campaign_participants"
  add_foreign_key "campaign_participants", "campaigns"
  add_foreign_key "campaign_rewards", "campaign_participant_epochs"
end
