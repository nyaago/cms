class AddUpdatedBy < ActiveRecord::Migration
  def self.up
    rename_column(:articles, :user_id, :updated_by)
    add_column(:article_histories, :updated_by, :integer)
    add_column(:company_profile_widgets, :updated_by, :integer)
    add_column(:images, :updated_by, :integer)
    add_column(:layout_images, :updated_by, :integer)
    add_column(:post_settings, :updated_by, :integer)
    add_column(:rss_widgets, :updated_by, :integer)
    add_column(:search_engine_optimizations, :updated_by, :integer)
    add_column(:sites, :updated_by, :integer)
    add_column(:site_layouts, :updated_by, :integer)
    add_column(:site_settings, :updated_by, :integer)
    add_column(:site_widgets, :updated_by, :integer)
    add_column(:text_widgets, :updated_by, :integer)
    add_column(:users, :updated_by, :integer)
    add_column(:view_settings, :updated_by, :integer)
  end

  def self.down
    rename_column(:articles, :updated_by, :user_id)
    remove_column(:article_histories, :updated_by)
    remove_column(:company_profile_widgets, :updated_by)
    remove_column(:images, :updated_by)
    remove_column(:layout_images, :updated_by)
    remove_column(:post_settings, :updated_by)
    remove_column(:rss_widgets, :updated_by)
    remove_column(:search_engine_optimization, :updated_by)
    remove_column(:sites, :updated_by)
    remove_column(:site_layouts, :updated_by)
    remove_column(:site_settings, :updated_by)
    remove_column(:site_widgets, :updated_by)
    remove_column(:text_widgets, :updated_by)
    remove_column(:users, :updated_by)
    remove_column(:view_settings, :updated_by)
  end
end
