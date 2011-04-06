class IsTemporaryToArticles < ActiveRecord::Migration
  def self.up
    add_column(:articles, :is_temporary, :boolean)
  end

  def self.down
    remove_column(:articles, :is_temporary)
  end
end
