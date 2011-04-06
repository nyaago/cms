class AddAutoLogin < ActiveRecord::Migration
  def self.up
    add_column(:users, :auto_login, :boolean, :default => false)
  end

  def self.down
    remove_column(:users, :auto_login)
  end
end
