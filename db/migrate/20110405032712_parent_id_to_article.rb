class ParentIdToArticle < ActiveRecord::Migration
  def self.up
    add_column(:articles, :parent_id, :integer)
  end

  def self.down
    remove_column(:articles, :parent_id)
  end
end
