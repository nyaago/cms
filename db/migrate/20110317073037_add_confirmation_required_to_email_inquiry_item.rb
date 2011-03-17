class AddConfirmationRequiredToEmailInquiryItem < ActiveRecord::Migration
  def self.up
    add_column(:email_inquiry_items, :confirmation_required, :boolean)
  end

  def self.down
    remove_column(:email_inquiry_items, :confirmation_required)
  end
end
