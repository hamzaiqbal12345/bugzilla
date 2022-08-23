# frozen_string_literal: true

class AddDetailsToBugs < ActiveRecord::Migration[5.2]
  def change
    change_table :bugs, bulk: true do |t|
      t.integer :bug_type, null: false, default: 0
      t.integer :status, null: false, default: 0
      t.string :screenshot
    end
  end
end
