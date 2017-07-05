class CreateWaitings < ActiveRecord::Migration
  def change
    create_table :waitings do |t|
      t.integer :task_id, index: true
      t.integer :waiting_id, index: true

      t.timestamps null: false
    end
  end
end
