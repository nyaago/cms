class RemoveCssFromLayout < ActiveRecord::Migration
  def self.up
    remove_column(:site_layouts, :css)
  end

  def self.down
    add_column(:site_layouts, :css, :text)
  end
end
