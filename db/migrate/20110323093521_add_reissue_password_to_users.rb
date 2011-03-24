class AddReissuePasswordToUsers < ActiveRecord::Migration
  def self.up
    add_column(:users, :reissue_password, :string)
  end

  def self.down
    remove_column(:users, :reissue_password)
  end
end
