# frozen_string_literal: true

class Project < ApplicationRecord
  has_many :users_projects, dependent: :destroy
  has_many :users, through: :users_projects
  has_many :bugs, dependent: :destroy

  validates :title, :description, presence: true
end
