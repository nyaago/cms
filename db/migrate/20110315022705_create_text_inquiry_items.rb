class CreateTextInquiryItems < ActiveRecord::Migration
  def self.up
    create_table :text_inquiry_items do |t|
      t.references  :user
      t.string      :title, :limit => 100
      t.boolean     :multi_rows
      t.integer     :row_count
      t.boolean     :required,  :false
      t.timestamps
    end
  end

  def self.down
    drop_table :text_inquiry_items
  end
end
