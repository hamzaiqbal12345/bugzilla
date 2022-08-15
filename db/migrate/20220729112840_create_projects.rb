# frozen_string_literal: true

class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.string :title, null: false, default: ''
      t.text :description, null: false, default: ''
      t.references :creator

      t.timestamps
    end
  end
end
