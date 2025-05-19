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

ActiveRecord::Schema[8.0].define(version: 2025_05_06_141407) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "attendances", force: :cascade do |t|
    t.bigint "participant_id", null: false
    t.bigint "date_option_id", null: false
    t.string "status"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date_option_id"], name: "index_attendances_on_date_option_id"
    t.index ["participant_id"], name: "index_attendances_on_participant_id"
  end

  create_table "date_options", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_date_options_on_event_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.string "location"
    t.text "memo"
    t.string "status"
    t.string "url_hash"
    t.datetime "confirmed_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "admin_password"
  end

  create_table "expenses", force: :cascade do |t|
    t.string "name"
    t.integer "amount"
    t.bigint "event_id", null: false
    t.bigint "payer_id", null: false
    t.boolean "paid_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_expenses_on_event_id"
    t.index ["payer_id"], name: "index_expenses_on_payer_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.integer "quantity"
    t.bigint "event_id", null: false
    t.bigint "participant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_items_on_event_id"
    t.index ["participant_id"], name: "index_items_on_participant_id"
  end

  create_table "participants", force: :cascade do |t|
    t.string "name"
    t.bigint "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_participants_on_event_id"
  end

  add_foreign_key "attendances", "date_options"
  add_foreign_key "attendances", "participants"
  add_foreign_key "date_options", "events"
  add_foreign_key "expenses", "events"
  add_foreign_key "expenses", "participants", column: "payer_id"
  add_foreign_key "items", "events"
  add_foreign_key "items", "participants"
  add_foreign_key "participants", "events"
end
