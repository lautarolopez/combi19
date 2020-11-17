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

<<<<<<< HEAD
ActiveRecord::Schema.define(version: 2020_11_17_080316) do
=======
ActiveRecord::Schema.define(version: 2020_11_16_021029) do
>>>>>>> parent of 6bb9458 (Feature add and modify combi)

  create_table "cities", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "state", default: "", null: false
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
    t.integer "extra_id"
    t.integer "route_id"
    t.index ["extra_id"], name: "index_extras_routes_on_extra_id"
    t.index ["route_id"], name: "index_extras_routes_on_route_id"
  end

  create_table "routes", force: :cascade do |t|
    t.integer "origin_id"
    t.integer "destination_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

<<<<<<< HEAD
  create_table "travels", force: :cascade do |t|
    t.integer "driver_id"
    t.integer "route_id"
    t.integer "occupied"
    t.integer "capacity"
    t.datetime "date_departure"
    t.datetime "date_arrival"
    t.float "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

=======
>>>>>>> parent of 6bb9458 (Feature add and modify combi)
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
    t.date "birth_date", default: "2020-11-14", null: false
    t.string "role", default: "user", null: false
    t.boolean "suscribed", default: false, null: false
    t.index ["dni"], name: "index_users_on_dni", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
