# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20151001154615) do

  create_table "completed_deals", force: :cascade do |t|
    t.float    "price"
    t.string   "exchange"
    t.string   "location"
    t.string   "commodity"
    t.integer  "seller_id"
    t.integer  "buyer_id"
    t.boolean  "fulfilled"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "pending_deal_id"
    t.boolean  "fulfilled_buyer"
    t.boolean  "fulfilled_seller"
    t.boolean  "complaint_buyer"
    t.boolean  "complaint_seller"
  end

  add_index "completed_deals", ["pending_deal_id"], name: "index_completed_deals_on_pending_deal_id", unique: true

  create_table "pending_deals", force: :cascade do |t|
    t.integer  "buyer_id"
    t.integer  "seller_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "product_id"
    t.float    "buyer_price"
    t.float    "seller_price"
    t.boolean  "completed"
    t.integer  "completed_deal_id"
    t.boolean  "active"
    t.boolean  "exchange_public_seller"
    t.boolean  "exchange_public_buyer"
    t.string   "seller_location"
    t.string   "buyer_location"
    t.integer  "buyer_hour"
    t.integer  "seller_hour"
    t.integer  "buyer_month"
    t.integer  "seller_month"
    t.integer  "buyer_day"
    t.integer  "seller_day"
    t.boolean  "seller_am"
    t.boolean  "buyer_am"
  end

  add_index "pending_deals", ["buyer_id"], name: "index_pending_deals_on_buyer_id"
  add_index "pending_deals", ["product_id", "seller_id", "buyer_id"], name: "index_pending_deals_on_product_id_and_seller_id_and_buyer_id", unique: true
  add_index "pending_deals", ["product_id"], name: "index_pending_deals_on_product_id"
  add_index "pending_deals", ["seller_id"], name: "index_pending_deals_on_seller_id"

  create_table "products", force: :cascade do |t|
    t.float    "price"
    t.string   "full_street_address"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "user_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "picture"
    t.text     "description"
    t.string   "commodity"
    t.boolean  "hold"
    t.boolean  "sold"
  end

  add_index "products", ["user_id"], name: "index_products_on_user_id"

  create_table "statuses", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "minPrice"
    t.integer  "maxPrice"
    t.boolean  "buying"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "toTravel"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "full_street_address"
    t.string   "commodity"
    t.text     "description"
  end

  add_index "statuses", ["user_id"], name: "index_statuses_on_user_id"

  create_table "stores", force: :cascade do |t|
    t.string   "full_street_address"
    t.string   "name"
    t.integer  "business_days_pickup"
    t.integer  "user_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "picture"
    t.boolean  "mondayopen"
    t.time     "mondaystart"
    t.time     "mondayend"
    t.boolean  "tuesdayopen"
    t.time     "tuesdaystart"
    t.time     "tuesdayend"
    t.boolean  "wednesdayopen"
    t.time     "wednesdaystart"
    t.time     "wednesdayend"
    t.boolean  "thursdayopen"
    t.time     "thursdaystart"
    t.time     "thursdayend"
    t.boolean  "fridayopen"
    t.time     "fridaystart"
    t.time     "fridayend"
    t.boolean  "saturdayopen"
    t.time     "saturdaystart"
    t.time     "saturdayend"
    t.boolean  "sundayopen"
    t.time     "sundaystart"
    t.time     "sundayend"
  end

  add_index "stores", ["user_id"], name: "index_stores_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin",             default: false
    t.string   "activation_digest"
    t.boolean  "activated",         default: false
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.boolean  "public",            default: false
    t.text     "description"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["public"], name: "index_users_on_public"

end
