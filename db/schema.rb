# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180409122848) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "batches", force: :cascade do |t|
    t.string "reference"
    t.integer "status", default: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reference"], name: "index_batches_on_reference", unique: true
  end

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_clients_on_name", unique: true
  end

  create_table "delivery_services", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_delivery_services_on_name", unique: true
  end

  create_table "orders", force: :cascade do |t|
    t.string "reference"
    t.bigint "purchase_channel_id"
    t.bigint "client_id"
    t.bigint "delivery_service_id"
    t.float "total_value"
    t.json "line_items"
    t.bigint "batch_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["batch_id"], name: "index_orders_on_batch_id"
    t.index ["client_id"], name: "index_orders_on_client_id"
    t.index ["delivery_service_id"], name: "index_orders_on_delivery_service_id"
    t.index ["purchase_channel_id"], name: "index_orders_on_purchase_channel_id"
    t.index ["reference"], name: "index_orders_on_reference", unique: true
  end

  create_table "purchase_channels", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_purchase_channels_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "password_digest", default: "", null: false
    t.integer "role"
    t.bigint "purchase_channel_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["name"], name: "index_users_on_name", unique: true
    t.index ["purchase_channel_id"], name: "index_users_on_purchase_channel_id"
  end

  create_table "view_batch_reports", force: :cascade do |t|
  end

  add_foreign_key "orders", "batches"
  add_foreign_key "orders", "clients"
  add_foreign_key "orders", "delivery_services"
  add_foreign_key "orders", "purchase_channels"
  add_foreign_key "users", "purchase_channels"
end
