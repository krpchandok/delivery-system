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

ActiveRecord::Schema[8.1].define(version: 2026_09_06_200334) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "cars", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "make"
    t.string "model"
    t.datetime "updated_at", null: false
    t.integer "year"
  end

  create_table "deliveries", force: :cascade do |t|
    t.integer "attempt_count"
    t.datetime "created_at", null: false
    t.datetime "last_attempted_at"
    t.bigint "order_event_id", null: false
    t.integer "response_code"
    t.string "status"
    t.bigint "subscription_id", null: false
    t.datetime "updated_at", null: false
    t.index ["order_event_id"], name: "index_deliveries_on_order_event_id"
    t.index ["subscription_id"], name: "index_deliveries_on_subscription_id"
  end

  create_table "order_events", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "idempotency_key"
    t.string "order_id"
    t.jsonb "payload"
    t.string "status"
    t.datetime "updated_at", null: false
    t.index ["idempotency_key"], name: "index_order_events_on_idempotency_key", unique: true
  end

  create_table "subscriptions", force: :cascade do |t|
    t.boolean "active"
    t.datetime "created_at", null: false
    t.string "endpoint_url"
    t.string "event_types", default: [], array: true
    t.string "secret"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "deliveries", "order_events"
  add_foreign_key "deliveries", "subscriptions"
end
