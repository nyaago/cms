class AddGlobalNaviToSiteLayout < ActiveRecord::Migration
  def self.up
    add_column(:site_layouts, :global_navigation, :string, :limit => 20)
  end

  def self.down
    remove_column(:site_layouts, :global_navigation)
  end
end
