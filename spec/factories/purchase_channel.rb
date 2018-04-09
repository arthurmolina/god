FactoryBot.define do
  factory :purchase_channel do
    name             { Faker::StarWars.planet }
  end
end