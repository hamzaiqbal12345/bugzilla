class Bug < ApplicationRecord
  belongs_to :project
  belongs_to :assigned_to, class_name: :User, optional: true
  belongs_to :posted_by, class_name: :User

end
