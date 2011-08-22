class PresetHeaderImageToLayout < ActiveRecord::Migration
  def self.up
    add_column(:site_layouts, :preset_header_image, :string, :limit => 50)
  end

  def self.down
    remove_column(:site_layouts, :preset_header_image)
  end
end
