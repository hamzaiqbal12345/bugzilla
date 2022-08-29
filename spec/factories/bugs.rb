# frozen_string_literal: true

FactoryBot.define do
  factory :bug do
    title { Faker::Name.unique.name }
    description { Faker::Game.genre }
    deadline { Faker::Date.between(from: 7.days.ago, to: Time.zone.today) }
    bug_type { 'bug' }
    status { 'neew' }
  end
end
