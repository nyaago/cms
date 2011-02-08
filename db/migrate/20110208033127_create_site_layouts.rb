class CreateSiteLayouts < ActiveRecord::Migration
  def self.up
    create_table :site_layouts do |t|
      t.integer   :site_id
      t.string    :theme,         :limit => 20
      t.string    :skin_color,    :limit => 20
      t.string    :title_format,  :limit => 50
      t.string    :font_size,     :limit => 20
      t.string    :eye_catch_type,:limit => 20
      t.string    :layout_type,   :limit => 20
      t.string    :header_image_url,      :limit => 512
      t.string    :footer_image_url,      :limit => 512
      t.string    :logo_image_url,        :limit => 512
      t.string    :background_image_url,  :limit => 512
      t.string    :background_color,      :limit => 20
      t.timestamps
    end
  end

  def self.down
    drop_table :site_layouts
  end
end
