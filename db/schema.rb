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

ActiveRecord::Schema.define(:version => 20110408085326) do

  create_table "article_histories", :force => true do |t|
    t.integer  "article_id",                                          :null => false
    t.integer  "site_id",                                             :null => false
    t.string   "title",            :limit => 50,                      :null => false
    t.string   "name",             :limit => 15
    t.text     "content"
    t.boolean  "published",                        :default => false
    t.integer  "menu_order",                       :default => 0
    t.integer  "integer",                          :default => 0
    t.boolean  "is_home",                          :default => false
    t.integer  "user_id"
    t.datetime "last_updated_at"
    t.datetime "backed_up_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "meta_description", :limit => 1000
    t.string   "meta_keywords",    :limit => 256
    t.boolean  "ignore_meta"
    t.datetime "published_from"
    t.string   "type"
    t.integer  "updated_by"
    t.string   "column_layout",    :limit => 20
    t.boolean  "is_temporary"
    t.integer  "parent_id"
  end

  create_table "articles", :force => true do |t|
    t.integer  "site_id",                                             :null => false
    t.string   "title",            :limit => 50,                      :null => false
    t.string   "name",             :limit => 15
    t.text     "content"
    t.boolean  "published",                        :default => false
    t.integer  "menu_order",                       :default => 0
    t.boolean  "is_home",                          :default => false
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "published_from"
    t.string   "meta_description", :limit => 1000
    t.string   "meta_keywords",    :limit => 256
    t.boolean  "ignore_meta"
    t.string   "type"
    t.boolean  "is_temporary"
    t.integer  "parent_id"
    t.string   "column_layout",    :limit => 20
  end

  create_table "checkbox_inquiry_items", :force => true do |t|
    t.integer  "user_id"
    t.string   "title",          :limit => 100
    t.boolean  "default_status",                :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "company_profile_widgets", :force => true do |t|
    t.string   "name",             :limit => 256
    t.string   "string",           :limit => 256
    t.string   "address",          :limit => 256
    t.string   "zip_code",         :limit => 20
    t.string   "tel_no",           :limit => 20
    t.string   "business_hours",   :limit => 256
    t.string   "regular_holidays", :limit => 256
    t.string   "email",            :limit => 256
    t.string   "link_url1",        :limit => 256
    t.string   "link_title1",      :limit => 256
    t.string   "link_url2",        :limit => 256
    t.string   "link_title2",      :limit => 256
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "updated_by"
  end

  create_table "email_inquiry_items", :force => true do |t|
    t.integer  "user_id"
    t.string   "title",                 :limit => 100
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "confirmation_required"
    t.boolean  "confirm_to"
  end

  create_table "images", :force => true do |t|
    t.integer  "site_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.string   "title",              :limit => 100
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "alternative",        :limit => 50
    t.boolean  "is_image"
    t.integer  "total_size"
    t.string   "caption"
    t.text     "description"
    t.integer  "updated_by"
  end

  create_table "information", :force => true do |t|
    t.string   "title",      :limit => 50, :null => false
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "layout_images", :force => true do |t|
    t.integer  "site_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.string   "location_type",      :limit => 20
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "updated_by"
  end

  create_table "post_settings", :force => true do |t|
    t.integer  "site_id"
    t.integer  "editor_row_count"
    t.string   "pop3_host"
    t.string   "pop3_login"
    t.string   "pop3_crypted_password"
    t.string   "pop3_password_salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "updated_by"
    t.integer  "pop3_port",             :limit => 2
    t.boolean  "pop3_ssl"
  end

  create_table "radio_inquiry_items", :force => true do |t|
    t.integer  "user_id"
    t.string   "title",         :limit => 100
    t.string   "value1",        :limit => 100
    t.string   "value2",        :limit => 100
    t.string   "value3",        :limit => 100
    t.string   "value4",        :limit => 100
    t.string   "value5",        :limit => 100
    t.string   "value6",        :limit => 100
    t.string   "value7",        :limit => 100
    t.integer  "default_index", :limit => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rss_widgets", :force => true do |t|
    t.string   "text",            :limit => 256
    t.string   "title",           :limit => 100
    t.integer  "entry_count"
    t.boolean  "include_creator"
    t.boolean  "include_date"
    t.boolean  "include_content"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "updated_by"
  end

  create_table "search_engine_optimizations", :force => true do |t|
    t.integer  "site_id",                                   :null => false
    t.boolean  "enabled",                :default => true
    t.boolean  "canonical_url_enabled",  :default => false
    t.boolean  "title_rewriting",        :default => true
    t.string   "page_title_format"
    t.string   "blog_title_format"
    t.string   "archive_title_format"
    t.string   "not_found_title_format"
    t.string   "page_keywords"
    t.string   "blog_keywords"
    t.string   "page_description"
    t.string   "blog_description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "updated_by"
  end

  create_table "site_inquiry_items", :force => true do |t|
    t.integer  "inquiry_item_id",                                   :null => false
    t.string   "inquiry_item_type",                                 :null => false
    t.integer  "site_id",                                           :null => false
    t.integer  "user_id"
    t.integer  "position",          :limit => 3
    t.boolean  "required",                       :default => false
    t.boolean  "displayed",                      :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "site_layouts", :force => true do |t|
    t.integer  "site_id"
    t.string   "theme",                   :limit => 20
    t.string   "skin_color",              :limit => 20
    t.string   "font_size",               :limit => 20
    t.string   "eye_catch_type",          :limit => 20
    t.string   "layout_type",             :limit => 20
    t.string   "header_image_url",        :limit => 512
    t.string   "footer_image_url",        :limit => 512
    t.string   "logo_image_url",          :limit => 512
    t.string   "background_image_url",    :limit => 512
    t.string   "background_color",        :limit => 20
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title_tag",               :limit => 20
    t.string   "title_tag_format",        :limit => 50
    t.string   "global_navigation",       :limit => 20
    t.string   "column_layout",           :limit => 20
    t.string   "eye_catch_type_location", :limit => 20
    t.string   "background_repeat",       :limit => 20
    t.integer  "updated_by"
  end

  create_table "site_settings", :force => true do |t|
    t.integer  "site_id",                        :null => false
    t.string   "date_format",      :limit => 50
    t.string   "time_format",      :limit => 50
    t.string   "analytics_script"
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "updated_by"
  end

  create_table "site_widgets", :force => true do |t|
    t.integer  "widget_id",                 :null => false
    t.string   "widget_type",               :null => false
    t.integer  "site_id",                   :null => false
    t.string   "area",        :limit => 30
    t.integer  "position",    :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "updated_by"
  end

  create_table "sites", :force => true do |t|
    t.string   "title",                    :limit => 50,                      :null => false
    t.string   "name",                     :limit => 15,                      :null => false
    t.boolean  "published",                                :default => false, :null => false
    t.boolean  "suspended",                                :default => false, :null => false
    t.boolean  "canceled",                                 :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description",              :limit => 1000
    t.string   "email",                    :limit => 250
    t.string   "copyright",                :limit => 50
    t.integer  "updated_by"
    t.integer  "max_mbyte",                                :default => 50
    t.datetime "cancellation_reserved_at"
    t.datetime "canceled_at"
  end

  create_table "text_inquiry_items", :force => true do |t|
    t.integer  "user_id"
    t.string   "title",      :limit => 100
    t.boolean  "multi_rows"
    t.integer  "row_count"
    t.boolean  "required"
    t.boolean  "false"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "text_widgets", :force => true do |t|
    t.string   "title",      :limit => 100
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "updated_by"
  end

  create_table "user_sessions", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.integer  "site_id"
    t.string   "login",                                  :null => false
    t.string   "email",                                  :null => false
    t.string   "persistence_token",                      :null => false
    t.string   "crypted_password",                       :null => false
    t.string   "password_salt",                          :null => false
    t.string   "single_access_token",                    :null => false
    t.integer  "login_count",         :default => 0,     :null => false
    t.integer  "failed_login_count",  :default => 0,     :null => false
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.datetime "last_request_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_admin"
    t.integer  "updated_by"
    t.boolean  "is_site_admin"
    t.string   "reissue_password"
    t.boolean  "auto_login",          :default => false
  end

  create_table "view_settings", :force => true do |t|
    t.integer  "site_id"
    t.integer  "title_count_in_home"
    t.integer  "article_count_per_page"
    t.string   "rss_type"
    t.integer  "article_count_of_rss"
    t.boolean  "view_whole_in_rss"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "updated_by"
  end

end
