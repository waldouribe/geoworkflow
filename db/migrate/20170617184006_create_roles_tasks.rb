class CreateRolesTasks < ActiveRecord::Migration
  def change
    create_table :roles_tasks, id: false do |t|
      t.references :role, index: true, foreign_key: true
      t.references :task, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
