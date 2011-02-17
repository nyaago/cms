class AddSeoToArticle < ActiveRecord::Migration
  def self.up
    add_column(:articles, :meta_description, :string, :limit => 1000)
    add_column(:articles, :meta_keywords, :string, :limit => 256)
    add_column(:articles, :ignore_meta, :boolean)
    remove_column(:articles, :keywords)
  end

  def self.down
    remove_column(:articles, :meta_description)
    remove_column(:articles, :meta_keywords)
    remove_column(:articles, :ignore_meta)
    add_column(:articles, :keywords, :string, :limit => 256)
  end
end
