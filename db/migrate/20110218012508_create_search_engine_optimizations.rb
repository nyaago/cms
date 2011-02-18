class CreateSearchEngineOptimizations < ActiveRecord::Migration
  def self.up
    create_table :search_engine_optimizations do |t|
      t.integer   :site_id,               :null => false
      t.boolean   :enabled  ,             :default => true
      t.boolean   :canonical_url_enabled, :default => false
      t.boolean   :title_rewriting      , :default => true
      t.string    :page_title_format
      t.string    :blog_title_format
      t.string    :archive_title_format
      t.string    :not_found_title_format
      t.string    :page_keywords
      t.string    :blog_keywords
      t.string    :page_description
      t.string    :blog_description
      t.timestamps
    end
  end

  def self.down
    drop_table :search_engine_optimizations
  end
end
