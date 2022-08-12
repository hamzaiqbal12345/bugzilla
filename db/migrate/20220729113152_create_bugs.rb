# frozen_string_literal: true

class CreateBugs < ActiveRecord::Migration[5.2]
  def change
    create_table :bugs do |t|
      t.string :title
      t.text :description
      t.datetime :deadline
      t.references :assigned_to
      t.references :project, foreign_key: true
      t.references :posted_by

      t.timestamps
    end
  end
end
