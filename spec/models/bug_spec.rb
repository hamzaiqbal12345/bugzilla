# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bug, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:project) }
    it { is_expected.to belong_to(:assigned_to).class_name(:User).optional }
    it { is_expected.to belong_to(:posted_by).class_name(:User).optional }
    it { is_expected.to have_one_attached(:screenshot) }
  end

  describe 'validations' do
    subject { build(:bug) }

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:bug_type) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_uniqueness_of(:title) }
  end
end
