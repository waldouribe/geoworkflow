class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :sender_id, index: true
      t.integer :receiver_id, index: true
      t.references :my_process, index: true, foreign_key: true
      t.text :message

      t.timestamps null: false
    end
  end
end
