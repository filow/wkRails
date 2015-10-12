class ChangeCfgValueToString < ActiveRecord::Migration
  def change
    remove_column :cfgs, :value, :text
    add_column :cfgs, :value, :string
  end
end
