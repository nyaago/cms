class AddInquiryLinkPosition < ActiveRecord::Migration
  def self.up
    add_column(:site_layouts, :inquiry_link_position, :string, :limit => 20)
  end

  def self.down
    remove_column(:site_layouts, :inquiry_link_position)
  end
end
