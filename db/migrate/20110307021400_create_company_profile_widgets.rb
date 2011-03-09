class CreateCompanyProfileWidgets < ActiveRecord::Migration
  def self.up
    create_table :company_profile_widgets do |t|
      t.string  :name,      :string,  :limit => 256
      t.string  :address,   :string,  :limit => 256
      t.string  :zip_code,  :string,  :limit => 20
      t.string  :tel_no,    :string,  :limit => 20
      t.string  :business_hours,    :string,  :limit => 256
      t.string  :regular_holidays,  :string,  :limit => 256
      t.string  :email,       :string,  :limit => 256
      t.string  :link_url1,   :string,  :limit => 256
      t.string  :link_title1, :string,:limit => 256
      t.string  :link_url2,   :string,  :limit => 256
      t.string  :link_title2, :string,:limit => 256
      t.timestamps
    end
  end

  def self.down
    drop_table :company_profile_widgets
  end
end
