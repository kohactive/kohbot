FactoryBot.define do
  factory :question, class: Question do
    user { FactoryBot.create(:user) }
    question { Faker::Lorem.question }

    trait :with_answers do
      after :create do |question|
        FactoryBot.create(:response, answer: Faker::Lorem.sentence, question: question)
        FactoryBot.create(:response, answer: Faker::Lorem.sentence, question: question)
        FactoryBot.create(:response, answer: Faker::Lorem.sentence, question: question)
      end
    end

    trait :is_open do
      open { true }
    end

  end
end