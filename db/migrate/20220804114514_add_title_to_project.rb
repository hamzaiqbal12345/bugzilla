# frozen_string_literal: true

class AddTitleToProject < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :title, :string, null: false
  end
end
