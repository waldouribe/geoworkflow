class AddColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :latitude, :float
    add_column :users, :longitude, :float
    add_column :users, :ip, :string
    add_column :users, :address, :string
  end
end
