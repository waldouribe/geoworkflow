class AddColumnsToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :work_link, :string
    add_column :tasks, :work_description, :text
  end
end
