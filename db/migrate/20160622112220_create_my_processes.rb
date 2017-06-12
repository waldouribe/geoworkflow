class CreateMyProcesses < ActiveRecord::Migration
  def change
    create_table :my_processes do |t|
      t.references :process_type, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.string :name
      t.string :hashtag
      t.string :address
      t.float :latitude
      t.float :longitude
      t.datetime :starts_at
      t.datetime :started_at
      t.datetime :ended_at

      t.timestamps null: false
    end
  end
end
