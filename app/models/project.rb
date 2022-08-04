class Project < ApplicationRecord
  has_many :users_projects, dependent: :destroy
  has_many :users, through: :users_projects
  has_many :bugs, dependent: :destroy

  validates :title, presence: true
end
