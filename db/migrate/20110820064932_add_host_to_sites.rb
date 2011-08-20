class AddHostToSites < ActiveRecord::Migration
  def self.up
    add_column(:sites, :host, :string, :limit => 256)
  end

  def self.down
    remove_column(:sites, :host)
  end
end
