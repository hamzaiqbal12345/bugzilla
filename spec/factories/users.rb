# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    role { 0 }
    password { '123456' }
    password_confirmation { '123456' }
    confirmed_at { Time.zone.today }
  end
end
