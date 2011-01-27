class AddToArticle < ActiveRecord::Migration
  def self.up
    add_column(:articles, :keywords, :string, :limit => 200)
    add_column(:article_histories, :keywords, :string, :limit => 200)
  end

  def self.down
    remove_column(:articles, :keywords)
    remove_column(:article_histories, :keywords)
  end
end
