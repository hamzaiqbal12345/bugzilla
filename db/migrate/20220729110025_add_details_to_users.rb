# frozen_string_literal: true

class AddDetailsToUsers < ActiveRecord::Migration[5.2]
  def change
    change_table :users, bulk: true do |t|
      t.string :name, null: false, default: ''
      t.integer :role, null: false, default: 1
    end
  end
end
