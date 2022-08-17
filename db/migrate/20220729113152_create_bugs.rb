# frozen_string_literal: true

class CreateBugs < ActiveRecord::Migration[5.2]
  def change
    create_table :bugs do |t|
      t.string :title, null: false, default: ''
      t.text :description, null: false, default: ''
      t.datetime :deadline, null: false, default: ''
      t.references :assigned_to
      t.references :project, foreign_key: true
      t.references :posted_by

      t.timestamps
    end
  end
end
