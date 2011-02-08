class AddToImages < ActiveRecord::Migration
  def self.up
    add_column(:images, :caption, :string)
    add_column(:images, :description, :text)
  end

  def self.down
    remove_column(:images, :caption)
    remove_column(:images, :description)
  end
end
