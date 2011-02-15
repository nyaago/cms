class AddBgRepeatToLayout < ActiveRecord::Migration
  def self.up
    add_column(:site_layouts, :background_repeat, :string, :limit => 20)
  end

  def self.down
    remove_column(:site_layouts, :background_repeat)
  end
end
