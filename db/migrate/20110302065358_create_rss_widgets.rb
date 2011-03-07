class CreateRssWidgets < ActiveRecord::Migration
  def self.up
    create_table :rss_widgets do |t|
      t.string      :text,  :limit => 256
      t.string      :title, :limit => 100
      t.integer     :entry_count
      t.boolean     :include_creator
      t.boolean     :include_date
      t.boolean     :include_content
      t.text        :content
      t.timestamps
    end
  end

  def self.down
    drop_table :rss_widgets
  end
end
