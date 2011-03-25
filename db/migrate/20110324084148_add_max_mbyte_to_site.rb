class AddMaxMbyteToSite < ActiveRecord::Migration
  def self.up
    add_column(:sites, :max_mbyte, :integer, :default => 50)
  end

  def self.down
    remove_column(:sites, :max_mbyte)
  end
end
