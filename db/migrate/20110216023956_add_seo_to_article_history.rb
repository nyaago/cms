class AddSeoToArticleHistory < ActiveRecord::Migration
  def self.up
    add_column(:article_histories, :meta_description, :string, :limit => 1000)
    add_column(:article_histories, :meta_keywords, :string, :limit => 256)
    add_column(:article_histories, :ignore_meta, :boolean)
    remove_column(:article_histories, :keywords)
    add_column(:article_histories, :published_from, :datetime)
  end

  def self.down
    remove_column(:article_histories, :meta_description)
    remove_column(:article_histories, :meta_keywords)
    remove_column(:article_histories, :ignore_meta)
    add_column(:article_histories, :keywords, :string, :limit => 256)
    remove_column(:article_histories, :published_from)
  end
end
