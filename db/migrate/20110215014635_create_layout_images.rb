class CreateLayoutImages < ActiveRecord::Migration
  def self.up
    create_table :layout_images do |t|
      t.integer :site_id
      t.string  :image_file_name
      t.string  :image_content_type
      t.integer :image_file_size
      t.string  :location_type, :limit => 20
      
      t.timestamps
    end
  end

  def self.down
    drop_table :layout_images
  end
end
