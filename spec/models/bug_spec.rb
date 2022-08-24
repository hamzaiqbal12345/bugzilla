require 'rails_helper'

RSpec.describe Bug, type: :model do
  describe 'associations' do
    it { should belong_to(:project) }
    it { should belong_to(:assigned_to).class_name(:User).optional }
    it { should belong_to(:posted_by).class_name(:User).optional }
    it { should have_one_attached(:screenshot) }
  end

  describe 'validations' do
    subject { build(:bug) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:bug_type) }
    it { should validate_presence_of(:status) }
    it { should validate_uniqueness_of(:title)}
  end
end
