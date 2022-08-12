# frozen_string_literal: true

class AddTitleToBug < ActiveRecord::Migration[5.2]
  def change
    add_column :bugs, :title, :string, null: false
  end
end
