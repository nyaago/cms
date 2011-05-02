class AddArticleToLayoutImage < ActiveRecord::Migration
  def self.up
    add_column(:layout_images, :article_id, :integer, :null => true)
  end

  def self.down
    remove_column(:layout_images, :article_id)
  end
end
