# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # , :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_many :users_projects, dependent: :destroy
  has_many :projects, through: :users_projects

  has_many :bugs, foreign_key: 'posted_by_id', inverse_of: 'posted_by', dependent: :destroy
  enum role: { manager: 0, developer: 1, qa: 2 }
end
