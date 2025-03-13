FactoryBot.define do
  factory :lesson_question do
    content { "Вопрос #{Faker::Lorem.sentence}" }
    association :lesson, optional: true
  end
end
