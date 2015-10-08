class CreateCfgs < ActiveRecord::Migration
  def change
    create_table :cfgs,options:"charset=utf8" do |t|
      t.string :key
      t.text :value
      t.string :remark
      t.string :field_type
    end
  end
end
