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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111030211705) do

  create_table "active_admin_comments", :force => true do |t|
    t.integer  "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "antiques", :force => true do |t|
    t.string   "name"
    t.string   "sku"
    t.text     "description"
    t.float    "width"
    t.float    "height"
    t.float    "depth"
    t.float    "weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ebay_auctions", :force => true do |t|
    t.string   "title"
    t.string   "item_number"
    t.string   "listing_status"
    t.string   "time_left"
    t.text     "description"
    t.decimal  "start_price",         :precision => 7, :scale => 2, :default => 0.99
    t.decimal  "current_price",       :precision => 7, :scale => 2, :default => 0.99
    t.decimal  "reserve_price",       :precision => 7, :scale => 2
    t.decimal  "buy_it_now_price",    :precision => 7, :scale => 2
    t.decimal  "shipping_price",      :precision => 7, :scale => 2
    t.integer  "antique_id"
    t.integer  "primary_category_id"
    t.integer  "winner_id"
    t.integer  "length"
    t.integer  "bids",                                              :default => 0
    t.integer  "hit_count",                                         :default => 0
    t.integer  "watch_count",                                       :default => 0
    t.boolean  "reserve_met",                                       :default => false
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "date_ended"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photos", :force => true do |t|
    t.integer  "antique_id"
    t.integer  "width"
    t.integer  "height"
    t.string   "title"
    t.string   "url"
    t.string   "page"
    t.string   "size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "flickr_id"
  end

end
