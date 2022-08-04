class RemoveTitleFromBug < ActiveRecord::Migration[5.2]
  def change
    remove_column :bugs, :title, :string
  end
end
