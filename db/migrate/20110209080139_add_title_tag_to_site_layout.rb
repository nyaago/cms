class AddTitleTagToSiteLayout < ActiveRecord::Migration
  def self.up
    add_column(:site_layouts, :title_tag, :string, :limit => 20)
    add_column(:site_layouts, :title_tag_format, :string, :limit => 50)
  end

  def self.down
    remove_column(:site_layouts, :title_tag)
    remove_column(:site_layouts, :title_tag_format)
  end
end
