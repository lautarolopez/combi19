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

ActiveRecord::Schema.define(version: 2020_12_16_082617) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cities", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "state", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "combis", force: :cascade do |t|
    t.string "category"
    t.string "licence_plate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "capacity", default: 0
  end

  create_table "comments", force: :cascade do |t|
    t.string "text"
    t.string "author"
    t.integer "user_id"
    t.integer "travel_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "extras", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.text "description"
    t.float "price", default: 0.0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_extras_on_name", unique: true
  end

  create_table "extras_routes", id: false, force: :cascade do |t|
    t.bigint "extra_id"
    t.bigint "route_id"
    t.index ["extra_id"], name: "index_extras_routes_on_extra_id"
    t.index ["route_id"], name: "index_extras_routes_on_route_id"
  end

  create_table "extras_tickets", id: false, force: :cascade do |t|
    t.bigint "extra_id"
    t.bigint "ticket_id"
    t.index ["extra_id"], name: "index_extras_tickets_on_extra_id"
    t.index ["ticket_id"], name: "index_extras_tickets_on_ticket_id"
  end

  create_table "payment_methods", force: :cascade do |t|
    t.integer "user_id"
    t.bigint "card_number"
    t.string "name"
    t.integer "expire_month"
    t.integer "expire_year"
    t.integer "verification_code"
    t.string "company"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "routes", force: :cascade do |t|
    t.integer "origin_id"
    t.integer "destination_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tickets", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "travel_id"
    t.float "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "payment_method"
    t.integer "status", default: 0
    t.index ["travel_id"], name: "index_tickets_on_travel_id"
    t.index ["user_id"], name: "index_tickets_on_user_id"
  end

  create_table "travels", force: :cascade do |t|
    t.integer "driver_id"
    t.integer "route_id"
    t.datetime "date_departure"
    t.datetime "date_arrival"
    t.float "price", default: 0.0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "combi_id"
    t.integer "discount", default: 0
    t.integer "recurrence", default: 0
    t.string "recurrence_name"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.integer "dni", default: 0, null: false
    t.date "birth_date", default: "2020-11-18", null: false
    t.string "role", default: "user", null: false
    t.boolean "subscribed", default: false, null: false
    t.date "discharge_date"
    t.integer "subscription_payment_method_id"
    t.boolean "not_covid", default: true
    t.index ["dni"], name: "index_users_on_dni", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "extras_routes", "extras"
  add_foreign_key "extras_routes", "routes"
  add_foreign_key "extras_tickets", "extras"
  add_foreign_key "extras_tickets", "tickets"
end
