class CreateWaitings < ActiveRecord::Migration
  def change
    create_table :waitings do |t|
      t.references :task, index: true, foreign_key: true
      t.references :waiting, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
