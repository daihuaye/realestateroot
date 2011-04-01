class AddStateDesToZipCode < ActiveRecord::Migration
  def self.up
    add_column :zip_codes, :state_des, :string
  end

  def self.down
    remove_column :zip_codes, :state_des
  end
end
