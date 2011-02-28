class AddTypeToArticle < ActiveRecord::Migration
  def self.up
    add_column(:articles, :type, :string)
    remove_column(:articles, :article_type)
    add_column(:article_histories, :type, :string)
    remove_column(:article_histories, :article_type)
    
  end

  def self.down
    remove_column(:articles, :type)
    add_column(:articles, :article_type, :integer)
#    remove_column(:article_histories, :type)
#    add_column(:article_histories, :article_type, :integer)
  end
end
