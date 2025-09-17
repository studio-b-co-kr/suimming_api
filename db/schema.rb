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

ActiveRecord::Schema[8.0].define(version: 2025_09_17_054037) do
  create_schema "ca_api_schema"
  create_schema "md_api_schema"
  create_schema "oms_api_schema"

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "postgres_fdw"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "announcement_to_investment_events", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.bigint "announcement_id", null: false
    t.bigint "investment_event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "change_logs", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "company_id"
    t.bigint "investment_id"
    t.string "event_type"
    t.json "value_before"
    t.json "value_after"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true, null: false, comment: "active/inactive"
    t.bigint "custom_field_template_id", comment: "custom field template ID"
    t.string "event_object", comment: "event object"
  end

  create_table "commitments", force: :cascade do |t|
    t.bigint "limited_partner_id", comment: "LP ID"
    t.bigint "legal_fund_id", comment: "펀드 ID"
    t.bigint "company_id", default: 0, null: false, comment: "company ID"
    t.float "commitment", default: 0.0, comment: "총 투자 금액"
    t.float "callable_capital", default: 0.0, comment: "잔여 투자 금액"
    t.boolean "active", default: true, null: false, comment: "active/inactive"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["legal_fund_id"], name: "index_commitments_on_legal_fund_id"
    t.index ["limited_partner_id"], name: "index_commitments_on_limited_partner_id"
  end

  create_table "connections", force: :cascade do |t|
    t.string "relationship", comment: "관계"
    t.bigint "from_contact_id", null: false, comment: "from contact id"
    t.bigint "to_contact_id", null: false, comment: "to contact id"
    t.string "memo", comment: "메모"
    t.date "remember_date", comment: "remember date"
    t.string "remember_group", comment: "remember group"
    t.boolean "active", default: true, null: false, comment: "active/inactive"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "shareable", default: false
    t.index ["from_contact_id"], name: "index_connections_on_from_contact_id"
    t.index ["to_contact_id"], name: "index_connections_on_to_contact_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "contact_name", comment: "연락처 명"
    t.bigint "entity_id", default: 0, null: false, comment: "Entity ID"
    t.string "phone_number", comment: "연락처 번호"
    t.string "email", comment: "연락 email"
    t.boolean "active", default: true, null: false, comment: "active/inactive"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id", default: 0, null: false, comment: "team ID"
    t.bigint "limited_partner_id", default: 0, null: false, comment: "Limited Partner ID"
    t.bigint "user_id", default: 0, null: false, comment: "user ID"
    t.string "department", comment: "부서"
    t.string "title", comment: "직책"
    t.string "address", comment: "주소"
    t.index ["entity_id"], name: "index_contacts_on_entity_id"
  end

  create_table "custom_field_templates", force: :cascade do |t|
    t.string "custom_field_name", comment: "custom field 명"
    t.string "field_type", comment: "field 종류"
    t.boolean "required", default: false, null: false, comment: "사용 여부"
    t.boolean "active", default: true, null: false, comment: "active/inactive"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "stage_id", default: 0, null: false, comment: "stage ID"
    t.bigint "company_id", default: 0, null: false, comment: "team ID"
    t.text "selectable_values", default: [], comment: "multiple options", array: true
    t.integer "sort_index"
    t.string "template_type", default: "investment", comment: "template 유형"
    t.json "rules", default: {}
    t.boolean "display_on_card", default: false
    t.bigint "mapping_dashboard_view_ids", default: [], comment: "mapping dashboard view id", array: true
    t.boolean "recurring", default: false, comment: "반복된 field"
  end

  create_table "custom_field_values", force: :cascade do |t|
    t.bigint "investment_id", null: false, comment: "investment ID"
    t.bigint "custom_field_template_id", null: false, comment: "custom field template ID"
    t.string "value", comment: "custom field 데이터"
    t.boolean "active", default: true, null: false, comment: "active/inactive"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id", default: 0, null: false, comment: "team ID"
    t.bigint "entity_id", comment: "company ID"
    t.index ["custom_field_template_id"], name: "index_custom_field_values_on_custom_field_template_id"
    t.index ["investment_id"], name: "index_custom_field_values_on_investment_id"
  end

  create_table "dashboard_views", force: :cascade do |t|
    t.string "dashboard_view_name", comment: "View Name"
    t.bigint "user_id", default: 0, null: false, comment: "company ID"
    t.json "filters", default: {}, null: false, comment: "filters for the specific views"
    t.bigint "company_id", default: 0, null: false, comment: "company ID"
    t.boolean "active", default: true, null: false, comment: "active/inactive"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "group_by_custom_template_id", default: 0, null: false, comment: "custom_template_id for grouping"
    t.string "view_layout", default: "Card", comment: "view layout (Card/List)"
    t.bigint "mapping_field_template_ids", default: [], comment: "mapping custom_field_template ids", array: true
  end

  create_table "entities", force: :cascade do |t|
    t.string "entity_name", comment: "Name of investment company"
    t.boolean "active", default: true, null: false, comment: "active/inactive"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id", default: 0, null: false, comment: "team ID"
  end

  create_table "investment_events", force: :cascade do |t|
    t.bigint "company_id", default: 0, null: false, comment: "company ID"
    t.bigint "created_by_user_id", comment: "user that created the event"
    t.string "title", default: ""
    t.string "description", default: ""
    t.date "event_on", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "investments", force: :cascade do |t|
    t.string "investment_name", comment: "investment 명"
    t.bigint "stage_id", null: false, comment: "stage ID"
    t.bigint "entity_id", comment: "기관명"
    t.boolean "active", default: true, null: false, comment: "active/inactive"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id", default: 0, null: false, comment: "team ID"
    t.bigint "owner_ids", default: [], null: false, comment: "owner ID", array: true
    t.index ["stage_id"], name: "index_investments_on_stage_id"
  end

  create_table "jwt_denylists", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "jti", null: false
    t.datetime "exp", precision: nil, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jti"], name: "index_jwt_denylists_on_jti", unique: true
  end

  create_table "limited_partners", force: :cascade do |t|
    t.string "limited_partner_name", comment: "LP 명"
    t.bigint "company_id", default: 0, null: false, comment: "company ID"
    t.boolean "active", default: true, null: false, comment: "active/inactive"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "meeting_notes", force: :cascade do |t|
    t.string "title", comment: "Meeting Note Title"
    t.string "meeting_type", comment: "미팅 종류"
    t.json "contacts", default: {}, comment: "참석자 contacts"
    t.bigint "owner_id", default: 0, comment: "owner ID"
    t.bigint "investment_id", default: 0, comment: "Investment ID"
    t.date "meeting_date", comment: "remember date"
    t.string "memo", comment: "memo"
    t.boolean "shareable", default: false, comment: "공유 여부"
    t.bigint "company_id", default: 0, null: false, comment: "company ID"
    t.boolean "active", default: true, null: false, comment: "active/inactive"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stages", force: :cascade do |t|
    t.string "stage_name", comment: "stage 명칭"
    t.boolean "active", default: true, null: false, comment: "active/inactive"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "column_index"
    t.bigint "company_id", default: 0, null: false, comment: "team ID"
  end

  create_table "telegram_approvals", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "telegram_id", default: ""
    t.string "approve_for_telegram_id", default: ""
    t.string "approve_telegram_id", default: ""
    t.string "approve_telegram_first_name", default: ""
    t.string "approve_telegram_last_name", default: ""
    t.string "approve_telegram_username", default: ""
    t.string "approve_status", default: "", comment: "approve,disapprove,skip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["telegram_id", "approve_telegram_id"], name: "idx_on_telegram_id_approve_telegram_id_d3d29ed83c", unique: true
  end

  create_table "telegram_connections", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "telegram_id", default: ""
    t.bigint "connected_user_id", default: 0, null: false
    t.string "connected_telegram_id", default: ""
    t.string "connected_telegram_first_name", default: ""
    t.string "connected_telegram_last_name", default: ""
    t.string "connected_telegram_username", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["telegram_id", "connected_telegram_id"], name: "idx_on_telegram_id_connected_telegram_id_1a3749f38a", unique: true
  end

  create_table "telegram_verify_requests", force: :cascade do |t|
    t.bigint "request_by_user_id", null: false
    t.string "request_by_telegram_id", default: ""
    t.string "request_on_telegram_id", default: ""
    t.string "request_on_telegram_first_name", default: ""
    t.string "request_on_telegram_last_name", default: ""
    t.string "request_on_telegram_username", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "telegram_id", default: ""
    t.string "telegram_first_name", default: ""
    t.string "telegram_last_name", default: ""
    t.string "telegram_username", default: ""
    t.string "telegram_language_code", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "versions", force: :cascade do |t|
    t.string "latest_version", default: ""
    t.string "minimum_version", default: ""
    t.datetime "released_at", default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
