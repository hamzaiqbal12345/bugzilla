require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'associations' do
    it { should have_many(:users) }
    it { should have_many(:bugs) }
  end

  describe 'validations' do
    subject { build(:project) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
  end
end
