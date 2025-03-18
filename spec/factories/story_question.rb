FactoryBot.define do
  factory :story_question do
    question { "Вопрос #{Faker::Lorem.sentence}" }
    answer { "Ответ" }
    association :story, optional: true
  end
end
