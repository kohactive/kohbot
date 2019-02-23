FactoryBot.define do
  factory :user, class: User do
    ucode { Faker::Lorem.characters(8) }
    active { true }

    trait :inactive do
      active { false }
    end
  end
end