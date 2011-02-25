class CreatePostSettings < ActiveRecord::Migration
  def self.up
    create_table :post_settings do |t|
      t.integer       :site_id
      t.integer       :editor_row_count
      t.string        :pop3_host
      t.string        :pop3_login
      t.string        :pop3_crypted_password
      t.string        :pop3_password_salt
      t.timestamps
    end
  end

  def self.down
    drop_table :post_settings
  end
end
