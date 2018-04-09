FactoryBot.define do
  factory :user, class: User do
    name             { Faker::StarWars.character }
    email            { "#{name.downcase.gsub(' ', '_')}@example.com".downcase }
    purchase_channel { create(:purchase_channel) }
    role             "admin"
    password         "password"
  end
end