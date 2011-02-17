class AddPublishedFromToArticle < ActiveRecord::Migration
  def self.up
    add_column(:articles, :published_from, :datetime)
  end

  def self.down
    remove_column(:articles, :published_from)
  end
end
