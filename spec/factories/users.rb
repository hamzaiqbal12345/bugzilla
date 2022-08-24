FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    role { Faker::Number.within(range: 0..2) }
    password { '123456' }
    password_confirmation { '123456' }
  end
end

# def user_with_bugs(bugs_count: 5)
#   FactoryBot.create(:user) do |user|
#     FactoryBot.create_list(:bug, bugs_count, user: user)
#   end
# end
