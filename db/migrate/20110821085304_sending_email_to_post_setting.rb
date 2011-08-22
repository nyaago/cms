class SendingEmailToPostSetting < ActiveRecord::Migration
  def self.up
    add_column(:post_settings, :from_address, :string, :limit => 256)
  end

  def self.down
    remove_column(:post_settings, :from_address)
  end
end
