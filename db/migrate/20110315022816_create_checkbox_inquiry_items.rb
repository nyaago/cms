class CreateCheckboxInquiryItems < ActiveRecord::Migration
  def self.up
    create_table :checkbox_inquiry_items do |t|
      t.references  :user
      t.string      :title, :limit => 100
      t.boolean     :default_status,  :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :checkbox_inquiry_items
  end
end
