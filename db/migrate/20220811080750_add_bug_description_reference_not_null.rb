# frozen_string_literal: true

class AddBugDescriptionReferenceNotNull < ActiveRecord::Migration[5.2]
  def change
    change_column_null :bugs, :description, false
  end
end
