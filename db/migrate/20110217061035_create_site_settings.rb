class CreateSiteSettings < ActiveRecord::Migration
  def self.up
    create_table :site_settings do |t|
      t.integer     :site_id,     :null => false
      t.string      :date_format, :limit => 50
      t.string      :time_format, :limit => 50
      t.string      :analytics_script, :text
      t.timestamps
    end
  end

  def self.down
    drop_table :site_settings
  end
end
