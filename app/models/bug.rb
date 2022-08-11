class Bug < ApplicationRecord
  belongs_to :project
  belongs_to :assigned_to, class_name: :User, optional: true
  belongs_to :posted_by, class_name: :User, optional: true

  has_one_attached :screenshot

  validate :correct_image_type

  validates :title, :bug_type, :status, presence: true
  validates_uniqueness_of :title, scope: :project_id

  enum bug_type: %i[bug feature]
  enum status: %i[neew started completed resolved]

  private

  def correct_image_type
    errors.add(:screenshot, 'must be a PNG or GIF') unless screenshot.content_type.in?(%w[image/png image/gif])
  end
end
