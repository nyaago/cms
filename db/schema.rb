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

ActiveRecord::Schema.define(:version => 20110121032430) do

  create_table "articles", :force => true do |t|
    t.integer  "site_id",                                        :null => false
    t.integer  "heading_level", :limit => 1,  :default => 1,     :null => false
    t.string   "title",         :limit => 50,                    :null => false
    t.text     "content"
    t.integer  "article_type",  :limit => 1,                     :null => false
    t.boolean  "published",                   :default => false
    t.integer  "member_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "members", :force => true do |t|
    t.integer  "site_id",                         :null => false
    t.string   "account",          :limit => 32,  :null => false
    t.string   "crypted_password", :limit => 32,  :null => false
    t.string   "salt",             :limit => 32,  :null => false
    t.string   "email",            :limit => 256, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "page_articles", :force => true do |t|
    t.integer  "page_id",                    :null => false
    t.integer  "article_id",                 :null => false
    t.integer  "parent_id"
    t.integer  "order_in_page", :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", :force => true do |t|
    t.integer  "site_id",                  :null => false
    t.string   "title",      :limit => 50
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sites", :force => true do |t|
    t.string   "name",       :limit => 50,                    :null => false
    t.boolean  "published",                :default => false, :null => false
    t.boolean  "suspended",                :default => false, :null => false
    t.boolean  "canceled",                 :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_sessions", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.integer  "site_id",                            :null => false
    t.string   "login",                              :null => false
    t.string   "email",                              :null => false
    t.string   "persistence_token",                  :null => false
    t.string   "crypted_password",                   :null => false
    t.string   "password_salt",                      :null => false
    t.string   "single_access_token",                :null => false
    t.string   "peristable_token",                   :null => false
    t.integer  "login_count",         :default => 0, :null => false
    t.integer  "failed_login_count",  :default => 0, :null => false
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.datetime "last_request_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
