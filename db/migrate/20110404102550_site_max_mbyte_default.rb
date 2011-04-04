class SiteMaxMbyteDefault < ActiveRecord::Migration
  def self.up
    change_column(:sites, :max_mbyte, :integer, :default => 50)
  end

  def self.down
  end
end
