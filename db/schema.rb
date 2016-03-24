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

ActiveRecord::Schema.define(version: 20160324044617) do

  create_table "attribute_options", force: :cascade do |t|
    t.integer  "category_option_id"
    t.string   "value"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "attribute_options", ["category_option_id"], name: "index_attribute_options_on_category_option_id"

  create_table "blogposts", force: :cascade do |t|
    t.text     "title"
    t.text     "content"
    t.integer  "store_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
  end

  add_index "blogposts", ["store_id"], name: "index_blogposts_on_store_id"
  add_index "blogposts", ["user_id"], name: "index_blogposts_on_user_id"

  create_table "bugs", force: :cascade do |t|
    t.text     "title"
    t.text     "content"
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "fixed"
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "categories", ["parent_id"], name: "index_categories_on_parent_id"

  create_table "category_options", force: :cascade do |t|
    t.integer  "category_id"
    t.string   "name"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "required",    default: false
  end

  add_index "category_options", ["category_id"], name: "index_category_options_on_category_id"

  create_table "conversations", force: :cascade do |t|
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "first_user_id"
    t.integer  "second_user_id"
    t.boolean  "active"
  end

  add_index "conversations", ["first_user_id"], name: "index_conversations_on_first_user_id"
  add_index "conversations", ["second_user_id"], name: "index_conversations_on_second_user_id"

  create_table "deals", force: :cascade do |t|
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "selling_method_id"
    t.integer  "exchange_method_id"
    t.integer  "payment_method_id"
    t.boolean  "deal_complete"
    t.boolean  "payment_complete"
    t.boolean  "product_received"
    t.integer  "product_id"
    t.integer  "seller_id"
    t.integer  "buyer_id"
    t.string   "dropoff"
    t.decimal  "user_proposed_price"
    t.boolean  "agreement_achieved"
    t.boolean  "proposed_price_accepted"
    t.boolean  "exchange_agreement_buyer"
    t.boolean  "exchange_agreement_seller"
    t.boolean  "buyer_satisfied"
    t.boolean  "seller_satisfied"
    t.boolean  "product_dispatched"
  end

  add_index "deals", ["buyer_id"], name: "index_deals_on_buyer_id"
  add_index "deals", ["exchange_method_id"], name: "index_deals_on_exchange_method_id"
  add_index "deals", ["payment_method_id"], name: "index_deals_on_payment_method_id"
  add_index "deals", ["product_id"], name: "index_deals_on_product_id"
  add_index "deals", ["seller_id"], name: "index_deals_on_seller_id"
  add_index "deals", ["selling_method_id"], name: "index_deals_on_selling_method_id"

  create_table "exchange_method_links", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "exchange_method_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "exchange_method_links", ["exchange_method_id"], name: "index_exchange_method_links_on_exchange_method_id"
  add_index "exchange_method_links", ["product_id"], name: "index_exchange_method_links_on_product_id"

  create_table "exchange_methods", force: :cascade do |t|
    t.string   "method"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "faqs", force: :cascade do |t|
    t.text     "question"
    t.text     "answer"
    t.integer  "store_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "faqs", ["store_id"], name: "index_faqs_on_store_id"

  create_table "messages", force: :cascade do |t|
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "conversation_id"
    t.integer  "sender_id"
    t.text     "content"
  end

  add_index "messages", ["conversation_id"], name: "index_messages_on_conversation_id"
  add_index "messages", ["sender_id"], name: "index_messages_on_sender_id"

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "message"
    t.boolean  "read"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payment_method_links", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "payment_method_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "payment_method_links", ["payment_method_id"], name: "index_payment_method_links_on_payment_method_id"
  add_index "payment_method_links", ["product_id"], name: "index_payment_method_links_on_product_id"

  create_table "payment_methods", force: :cascade do |t|
    t.string   "method"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pictures", force: :cascade do |t|
    t.integer  "product_id"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "photo_cropped_file_name"
    t.string   "photo_cropped_content_type"
    t.integer  "photo_cropped_file_size"
    t.datetime "photo_cropped_updated_at"
  end

  add_index "pictures", ["product_id"], name: "index_pictures_on_product_id"

  create_table "products", force: :cascade do |t|
    t.float    "price"
    t.string   "full_street_address"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "user_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.text     "description"
    t.boolean  "hold",                default: false
    t.boolean  "sold",                default: false
    t.integer  "store_id"
    t.string   "title"
    t.integer  "category_id"
    t.boolean  "request"
    t.decimal  "min_accepted_price"
    t.boolean  "fully_updated"
    t.decimal  "delivery_cost"
    t.boolean  "featured"
    t.boolean  "activated",           default: false
  end

  add_index "products", ["category_id"], name: "index_products_on_category_id"
  add_index "products", ["user_id"], name: "index_products_on_user_id"

  create_table "productviews", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "product_id"
    t.integer  "views",      default: 1
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "productviews", ["product_id"], name: "index_productviews_on_product_id"
  add_index "productviews", ["user_id", "product_id"], name: "index_productviews_on_user_id_and_product_id", unique: true
  add_index "productviews", ["user_id"], name: "index_productviews_on_user_id"

  create_table "reviews", force: :cascade do |t|
    t.integer  "deal_id"
    t.string   "verdict"
    t.string   "message"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "reviews", ["deal_id", "user_id"], name: "index_reviews_on_deal_id_and_user_id", unique: true
  add_index "reviews", ["deal_id"], name: "index_reviews_on_deal_id"
  add_index "reviews", ["user_id"], name: "index_reviews_on_user_id"

  create_table "search_relationships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "search_id"
    t.integer  "frequency",  default: 1
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "search_relationships", ["search_id"], name: "index_search_relationships_on_search_id"
  add_index "search_relationships", ["user_id", "search_id"], name: "index_search_relationships_on_user_id_and_search_id", unique: true
  add_index "search_relationships", ["user_id"], name: "index_search_relationships_on_user_id"

  create_table "searches", force: :cascade do |t|
    t.string   "search_text"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "searches", ["search_text"], name: "index_searches_on_user_id_and_search_text", unique: true

  create_table "selling_method_links", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "selling_method_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "selling_method_links", ["product_id"], name: "index_selling_method_links_on_product_id"
  add_index "selling_method_links", ["selling_method_id"], name: "index_selling_method_links_on_selling_method_id"

  create_table "selling_methods", force: :cascade do |t|
    t.string   "method"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stores", force: :cascade do |t|
    t.string   "full_street_address"
    t.string   "name"
    t.integer  "business_days_pickup"
    t.integer  "user_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
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
    t.string   "specialty_commodity"
    t.string   "phone"
    t.string   "profile_picture_file_name"
    t.string   "profile_picture_content_type"
    t.integer  "profile_picture_file_size"
    t.datetime "profile_picture_updated_at"
  end

  add_index "stores", ["user_id"], name: "index_stores_on_user_id"

  create_table "toggle_options", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "attribute_option_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "toggle_options", ["attribute_option_id"], name: "index_toggle_options_on_attribute_option_id"
  add_index "toggle_options", ["product_id"], name: "index_toggle_options_on_product_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin",                        default: false
    t.string   "activation_digest"
    t.boolean  "activated",                    default: false
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.boolean  "public",                       default: false
    t.text     "description"
    t.string   "auth_token"
    t.datetime "auth_expiry"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "full_street_address"
    t.text     "interests"
    t.integer  "products_bought"
    t.integer  "products_sold"
    t.text     "identifies_as"
<<<<<<< HEAD
    t.integer  "business_days_pickup"
    t.decimal  "default_delivery_cost"
    t.string   "profile_picture_file_name"
    t.string   "profile_picture_content_type"
    t.integer  "profile_picture_file_size"
    t.datetime "profile_picture_updated_at"
=======
    t.string   "profile_picture"
    t.integer  "business_days_pickup"
    t.decimal  "default_delivery_cost"
>>>>>>> notifications
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["public"], name: "index_users_on_public"

end
