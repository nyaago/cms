class AddToSite < ActiveRecord::Migration
  def self.up
    add_column(:sites, :description, :string, :limit => 1000)
    add_column(:sites, :email, :string, :limit => 250)
    add_column(:sites, :copyright, :string, :limit => 50)
  end

  def self.down
    remove_column(:sites, :description)
    remove_column(:sites, :email)
    remove_column(:sites, :copyright)
  end
end
