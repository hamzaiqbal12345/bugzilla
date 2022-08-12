# frozen_string_literal: true

class RemoveTitleFromProject < ActiveRecord::Migration[5.2]
  def change
    remove_column :projects, :title, :string
  end
end
