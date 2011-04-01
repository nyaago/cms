class CancelationReservedAt < ActiveRecord::Migration
  def self.up
    add_column(:sites, :cancellation_reserved_at, :timestamp)
    add_column(:sites, :canceled_at, :timestamp)
  end

  def self.down
    remove_column(:sites, :cancellation_reserved_at)
    remove_column(:sites, :canceled_at)
  end
  
end
