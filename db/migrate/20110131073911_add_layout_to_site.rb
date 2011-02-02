class AddLayoutToSite < ActiveRecord::Migration
  def self.up
    add_column(:sites, :template, :string, :limit => 25)
    add_column(:sites, :theme, :string, :limit => 25)
  end

  def self.down
    remove_column(:sites, :template)
    remove_column(:sites, :theme)
  end
end
