FactoryBot.define do
  factory :bug do
    title { Faker::Name.unique.name }
    deadline { Faker::Date.between(from: 7.days.ago, to: Date.today) }
    bug_type { Faker::Number.within(range: 0..1) }
    status { 0 }
  end
end
