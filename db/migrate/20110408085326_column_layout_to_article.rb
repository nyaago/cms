class ColumnLayoutToArticle < ActiveRecord::Migration
  def self.up
    add_column(:articles, :column_layout, :string, :limit => 20)
    add_column(:article_histories, :column_layout, :string, :limit => 20)
    add_column(:article_histories, :is_temporary, :boolean)
    add_column(:article_histories, :parent_id, :integer)
  end

  def self.down
  remove_column(:articles, :column_layout)
  remove_column(:article_histories, :column_layout)
  remove_column(:article_histories, :is_temporary)
  remove_column(:article_histories, :parent_id)
  end
end
