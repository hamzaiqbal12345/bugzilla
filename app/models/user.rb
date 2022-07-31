class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :users_projects
  has_many :projects, through: :users_projects

  has_many :projects, foreign_key: :creater_id, dependent: :destroy
  has_many :bugs, through: :projects
end
