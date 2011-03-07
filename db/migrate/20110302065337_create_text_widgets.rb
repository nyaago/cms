class CreateTextWidgets < ActiveRecord::Migration
  def self.up
    create_table :text_widgets do |t|
      t.string      :title, :limit => 100
      t.text        :content
      t.timestamps
    end
  end

  def self.down
    drop_table :text_widgets
  end
end
