class RmLayoutFromSite < ActiveRecord::Migration
  def self.up
    remove_column(:sites, :template)
    remove_column(:sites, :theme)
  end

  def self.down
    add_column(:sites, :template, :string, :limit => 25)
    add_column(:sites, :theme, :string, :limit => 25)
    
  end
end
