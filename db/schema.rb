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

ActiveRecord::Schema.define(version: 20160127185959) do

  create_table "blogposts", force: :cascade do |t|
    t.text     "title"
    t.text     "content"
    t.integer  "store_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "blogposts", ["store_id"], name: "index_blogposts_on_store_id"

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

  create_table "faqs", force: :cascade do |t|
    t.text     "question"
    t.text     "answer"
    t.integer  "store_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "faqs", ["store_id"], name: "index_faqs_on_store_id"

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "message"
    t.boolean  "read"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

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
    t.datetime "buyer_datetime"
    t.datetime "seller_datetime"
    t.string   "buyer_exchange"
    t.string   "seller_exchange"
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
    t.integer  "store_id"
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
    t.boolean  "mondayopen"
    t.boolean  "tuesdayopen"
    t.boolean  "wednesdayopen"
    t.boolean  "thursdayopen"
    t.boolean  "fridayopen"
    t.boolean  "saturdayopen"
    t.boolean  "sundayopen"
    t.string   "description"
    t.integer  "mondaystarthour"
    t.integer  "mondaystartminute"
    t.string   "mondaystartampm"
    t.integer  "tuesdaystarthour"
    t.integer  "tuesdaystartminute"
    t.string   "tuesdaystartampm"
    t.integer  "wednesdaystarthour"
    t.integer  "wednesdaystartminute"
    t.string   "wednesdaystartampm"
    t.integer  "thursdaystarthour"
    t.integer  "thursdaystartminute"
    t.string   "thursdaystartampm"
    t.integer  "fridaystarthour"
    t.integer  "fridaystartminute"
    t.string   "fridaystartampm"
    t.integer  "saturdaystarthour"
    t.integer  "saturdaystartminute"
    t.string   "saturdaystartampm"
    t.integer  "sundaystarthour"
    t.integer  "sundaystartminute"
    t.string   "sundaystartampm"
    t.integer  "mondayendhour"
    t.integer  "mondayendminute"
    t.string   "mondayendampm"
    t.integer  "tuesdayendhour"
    t.integer  "tuesdayendminute"
    t.string   "tuesdayendampm"
    t.integer  "wednesdayendhour"
    t.integer  "wednesdayendminute"
    t.string   "wednesdayendampm"
    t.integer  "thursdayendhour"
    t.integer  "thursdayendminute"
    t.string   "thursdayendampm"
    t.integer  "fridayendhour"
    t.integer  "fridayendminute"
    t.string   "fridayendampm"
    t.integer  "saturdayendhour"
    t.integer  "saturdayendminute"
    t.string   "saturdayendampm"
    t.integer  "sundayendhour"
    t.integer  "sundayendminute"
    t.string   "sundayendampm"
    t.string   "cover_photo"
    t.string   "profile_photo"
    t.string   "specialty_commodity"
    t.string   "phone"
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
    t.string   "auth_token"
    t.datetime "auth_expiry"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["public"], name: "index_users_on_public"

end
