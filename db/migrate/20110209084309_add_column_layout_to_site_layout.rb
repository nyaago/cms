class AddColumnLayoutToSiteLayout < ActiveRecord::Migration
  def self.up
    add_column(:site_layouts, :column_layout, :string, :limit => 20)
  end

  def self.down
    remove_column(:site_layouts, :column_layout)
  end
end
