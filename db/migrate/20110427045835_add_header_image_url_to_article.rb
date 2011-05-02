class AddHeaderImageUrlToArticle < ActiveRecord::Migration
  def self.up
    add_column(:articles, :header_image_url, :string)
    add_column(:article_histories, :header_image_url, :string)
  end

  def self.down
    remove_column(:articles, :header_image_url)
    remove_column(:article_histories, :header_image_url)
  end
end
