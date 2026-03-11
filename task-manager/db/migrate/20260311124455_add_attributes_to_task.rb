class AddAttributesToTask < ActiveRecord::Migration[8.1]
  def change
    add_column :tasks, :title, :string
    add_column :tasks, :description, :text
    add_column :tasks, :status, :string
    add_column :tasks, :priority, :integer
    add_column :tasks, :due_date, :datetime
  end
end
