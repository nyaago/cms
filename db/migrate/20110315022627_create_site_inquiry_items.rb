class CreateSiteInquiryItems < ActiveRecord::Migration
  def self.up
    create_table :site_inquiry_items do |t|
      t.references  :inquiry_item,    :polymorphic => true, :null => false
      t.references  :site,      :null => false
      t.references  :user
      t.integer     :position,  :limit => 3
      t.boolean     :required,  :default => false
      t.boolean     :displayed, :default => true
      t.timestamps
    end
  end

  def self.down
    drop_table :site_inquiry_items
  end
end
