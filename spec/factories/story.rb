FactoryBot.define do
  factory :story do
    name { "Сюжет #{Faker::Lorem.word}" }

    after(:create) do |story|
      create_list(:story_question, 3, story: story)
    end
  end
end
