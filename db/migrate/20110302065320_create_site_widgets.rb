class CreateSiteWidgets < ActiveRecord::Migration
  def self.up
    create_table :site_widgets do |t|
      t.references  :widget,    :polymorphic => true, :null => false
      t.references  :site,      :null => false
      t.string      :area,      :limit => 30
      t.integer     :position,  :limit => 5
      t.timestamps
    end
  end

  def self.down
    drop_table :site_widgets
  end
end
