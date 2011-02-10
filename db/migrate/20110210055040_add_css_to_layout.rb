class AddCssToLayout < ActiveRecord::Migration
  def self.up
    add_column(:site_layouts, :css, :text)
    remove_column(:site_layouts, :title_format)
  end

  def self.down
    remove_column(:site_layouts, :css)
    add_column(:site_layouts, :title_format, :string, :limit => 20)
  end
end
