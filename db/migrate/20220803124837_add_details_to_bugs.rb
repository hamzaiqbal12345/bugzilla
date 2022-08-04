class AddDetailsToBugs < ActiveRecord::Migration[5.2]
  def change
    add_column :bugs, :bug_type, :integer
    add_column :bugs, :status, :integer
    add_column :bugs, :screenshot, :string
  end
end
