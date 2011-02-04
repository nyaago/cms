class AddToImage < ActiveRecord::Migration
  def self.up
    add_column(:images, :alternative, :string, :limit => 50)
    add_column(:images, :is_image, :boolean)
    add_column(:images, :total_size, :integer)
  end

  def self.down
    remove_column(:images, :alternative)
    remove_column(:images, :is_image)
    remove_column(:images, :total_size)
  end
end
