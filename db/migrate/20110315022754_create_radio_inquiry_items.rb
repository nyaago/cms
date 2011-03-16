class CreateRadioInquiryItems < ActiveRecord::Migration
  def self.up
    create_table :radio_inquiry_items do |t|
      t.references  :user
      t.string      :title, :limit => 100
      t.string      :value1, :limit => 100
      t.string      :value2, :limit => 100
      t.string      :value3, :limit => 100
      t.string      :value4, :limit => 100
      t.string      :value5, :limit => 100
      t.string      :value6, :limit => 100
      t.string      :value7, :limit => 100
      t.integer     :default_index, :limit => 2
      t.timestamps
    end
  end

  def self.down
    drop_table :radio_inquiry_items
  end
end
