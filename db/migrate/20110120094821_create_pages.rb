class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.integer :site_id, :null => false
      t.string  :title, :limit => 50
      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end
