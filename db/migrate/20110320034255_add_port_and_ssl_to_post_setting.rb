class AddPortAndSslToPostSetting < ActiveRecord::Migration
  def self.up
    add_column(:post_settings, :pop3_port, :integer, :limit => 2)
    add_column(:post_settings, :pop3_ssl, :boolean)
  end

  def self.down
    remove_column(:post_settings, :pop3_port)
    remove_column(:post_settings, :pop3_ssl)
  end
end
