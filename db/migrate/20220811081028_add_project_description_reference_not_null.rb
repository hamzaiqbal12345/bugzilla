# frozen_string_literal: true

class AddProjectDescriptionReferenceNotNull < ActiveRecord::Migration[5.2]
  def change
    change_column_null :projects, :description, false
  end
end
