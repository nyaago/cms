class IsTemporaryToArticles < ActiveRecord::Migration
  def self.up
    add_column(:articles, :is_temporary, :boolean)
    remove_column(:articles, :integer)
  end

  def self.down
    remove_column(:articles, :is_temporary)
  end
end
