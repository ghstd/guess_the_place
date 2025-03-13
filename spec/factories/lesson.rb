FactoryBot.define do
  factory :lesson do
    name { "Lesson #{Faker::Lorem.word}" }

    after(:create) do |lesson|
      create_list(:lesson_question, 3, lesson: lesson)
    end
  end
end
