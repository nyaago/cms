class CreateEmailInquiryItems < ActiveRecord::Migration
  def self.up
    create_table :email_inquiry_items do |t|
      t.references  :user
      t.string      :title, :limit => 100
      t.timestamps
    end
  end

  def self.down
    drop_table :email_inquiry_items
  end
end
