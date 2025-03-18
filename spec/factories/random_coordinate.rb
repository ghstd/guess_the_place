FactoryBot.define do
  factory :random_coordinate do
    lat { Faker::Address.latitude }
    long { Faker::Address.longitude }
  end
end
