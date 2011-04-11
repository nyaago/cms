class UpatedByToInformation < ActiveRecord::Migration
  def self.up
    add_column(:information, :updated_by, :integer)
  end

  def self.down
    remove_column(:information, :updated_by)
  end
end
