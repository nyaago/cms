class CreatePageArticles < ActiveRecord::Migration
  def self.up
    create_table :page_articles do |t|
      t.integer :page_id, :null => false
      t.integer :article_id, :null => false
      t.integer :parent_id, :null => true
      t.integer :order_in_page, :limit => 5
      t.timestamps
    end
  end

  def self.down
    drop_table :page_articles
  end
end
