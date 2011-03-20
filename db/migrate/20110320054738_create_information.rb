class CreateInformation < ActiveRecord::Migration
  def self.up
    create_table :information do |t|
      t.string  :title,  :limit => 50, :null => false
      t.text    :content,  :null => true 
      t.timestamps
    end
  end

  def self.down
    drop_table :information
  end
end
