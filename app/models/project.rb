class Project < ApplicationRecord
  belongs_to :creater, class_name: :User

  has_many :users_projects, dependent: :delete_all
  has_many :users, through: :users_projects

  has_many :bugs, dependent: :destroy
end
