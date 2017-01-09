class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.references :my_process, index: true, foreign_key: true
      t.references :responsible_user, index: true
      t.string :address
      t.string :name
      t.text :description
      t.float :latitude
      t.float :longitude      
      t.datetime :assigned_start
      t.datetime :assigned_end
      t.datetime :actual_start
      t.datetime :actual_end
      
      t.timestamps null: false
    end
  end
end
