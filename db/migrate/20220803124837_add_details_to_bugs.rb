# frozen_string_literal: true

class AddDetailsToBugs < ActiveRecord::Migration[5.2]
  def change
    change_table :bugs, bulk: true do |t|
      t.integer :bug_type
      t.integer :status
      t.string :screenshot
    end
  end
end
