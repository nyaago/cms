class CreateViewSettings < ActiveRecord::Migration
  def self.up
    create_table :view_settings do |t|
      t.integer           :site_id
      t.integer           :title_count_in_home
      t.integer           :article_count_per_page
      t.string            :rss_type
      t.integer           :article_count_of_rss
      t.boolean           :view_whole_in_rss
      t.timestamps
    end
  end

  def self.down
    drop_table :view_settings
  end
end
