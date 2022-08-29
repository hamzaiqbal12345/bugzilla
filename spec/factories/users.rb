# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    role { 0 }
    password { '123456' }
    password_confirmation { '123456' }
    confirmed_at { Date.today }
  end
end

# def user_with_bugs(bugs_count: 5)
#   FactoryBot.create(:user) do |user|
#     FactoryBot.create_list(:bug, bugs_count, user: user)
#   end
# end
