class AddReplyToEmailInquiryItem < ActiveRecord::Migration
  def self.up
    add_column(:email_inquiry_items, :confirm_to, :boolean)
  end

  def self.down
    remove_column(:email_inquiry_items, :confirm_to)
  end
end
