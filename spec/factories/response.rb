FactoryBot.define do
  factory :response, class: Response do
    user { FactoryBot.create(:user) }
    answer { Faker::Lorem.sentence }
    association :question
  end
end