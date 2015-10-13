class CreateJoinTableRoleAdmin < ActiveRecord::Migration
  def change
    create_join_table :admins, :roles  do |t|
      # t.index [:role_id, :admin_id]
      t.index [:admin_id, :role_id]
    end
  end
end
