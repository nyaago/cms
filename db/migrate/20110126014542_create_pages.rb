class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string :title, :limit => 50, :null => false
      t.integer :site_id, :null => false
      t.string :description, :limit => 1000
      t.boolean :published, :default => false
      t.integer :menu_order, :limit => 4, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end
