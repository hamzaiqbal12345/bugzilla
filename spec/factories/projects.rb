# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    title { Faker::Game.title }
    description { Faker::Game.genre }
  end
end
