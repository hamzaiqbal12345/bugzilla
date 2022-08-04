class Bug < ApplicationRecord
  belongs_to :project
  belongs_to :assigned_to, class_name: :User, optional: true
  belongs_to :posted_by, class_name: :User, optional: true

  has_one_attached :screenshot

  validates :title,:bug_type, :status,  presence: true
  validates_uniqueness_of :title, scope: :project_id

  enum bug_type: [:bug, :feature, :improvement]
  enum status: [:neew, :started, :completed, :resolved]
end
