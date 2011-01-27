class CreateArticleHistories < ActiveRecord::Migration
  def self.up
    create_table :article_histories do |t|
      t.integer :article_id, :null => false
      t.integer :site_id, :null => false
      t.string  :title,  :limit => 50, :null => false
      t.string  :name,  :limit => 15, :null => true
      t.text    :content,  :null => true 
      t.integer :article_type,  :limit => 1, :null => false
      t.boolean :published, :default => false
      t.integer :menu_order, :integer, :limit => 4, :default => 0
      t.boolean :is_home, :default => false
      t.integer :user_id
      t.datetime :last_updated_at
      t.datetime :backed_up_at
      t.timestamps
    end
  end

  def self.down
    drop_table :article_histories
  end
end
