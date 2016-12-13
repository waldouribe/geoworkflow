class CreateProcessTypes < ActiveRecord::Migration
  def change
    create_table :process_types do |t|
      t.references :user, index: true, foreign_key: true
      t.string :name, index: true
      t.string :hashtag
      t.text :description

      t.timestamps null: false
    end
  end
end
