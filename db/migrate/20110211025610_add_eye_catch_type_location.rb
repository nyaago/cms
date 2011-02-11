class AddEyeCatchTypeLocation < ActiveRecord::Migration
  def self.up
    add_column(:site_layouts, :eye_catch_type_location, :string, :limit => 20)
  end

  def self.down
    remove_column(:site_layouts, :eye_catch_type_location)
  end
end
