class CreateSites < ActiveRecord::Migration
  def self.up
    create_table :sites do |t|
      t.string  :title, :limit => 50, :null => false
      t.string  :name, :limit => 15, :null => false
      t.boolean :published, :null => false, :default => false
      t.boolean :suspended, :null => false, :default => false
      t.boolean :canceled, :null => false, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :sites
  end
end
