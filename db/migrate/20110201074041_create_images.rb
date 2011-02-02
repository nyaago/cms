class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.integer :site_id
      t.string  :image_file_name
      t.string  :image_content_type
      t.integer :image_file_size
      t.string  :title, :limit => 100

      t.timestamps
    end
  end

  def self.down
    drop_table :images
  end
end
