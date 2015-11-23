class ChangeExpvideoThumbToBoolean < ActiveRecord::Migration
  def change
    remove_column :expvideos, :thumb, :string
    add_column :expvideos, :thumb, :boolean, default: false
  end
end
