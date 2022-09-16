# frozen_string_literal: true

class Bug < ApplicationRecord
  belongs_to :project
  belongs_to :assigned_to, class_name: :User, optional: true
  belongs_to :posted_by, class_name: :User, optional: true

  has_one_attached :screenshot

  validates :title, :bug_type, :status, presence: true
  validates :title, uniqueness: true

  enum bug_type: { bug: 0, feature: 1 }
  enum status: { neew: 0, started: 1, completed: 2, resolved: 3 }
end
