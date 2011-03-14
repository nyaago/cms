class AddSiteAdmin < ActiveRecord::Migration
  def self.up
    add_column(:users, :is_site_admin, :boolean)
  end

  def self.down
    remove_column(:users, :is_site_admin)
  end
end
