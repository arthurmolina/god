# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts 'Creating purchase channels...'
PurchaseChannel.create!(
  [
    {name: 'Site BR'},
    {name: 'Site US'},
    {name: 'Instagram BR'},
    {name: 'Pinterest BR'},
    {name: 'Twitter BR'},
    {name: 'Reselers'},
    {name: 'Iguatemi Store'},
    {name: 'Cidade São Paulo Store'},
    {name: 'Grand Plaza Store'},
    {name: 'Villa Lobos Store'}
  ])

puts 'Creating delivery services...'
DeliveryService.create!(
  [
    {name: 'SEDEX'},
    {name: 'Shipping Company'}
  ])

puts 'Creating clients...'
i = 0
while i < 10 do
  Client.create!(
    {
      name: Faker::StarWars.unique.character, 
      address: "#{Faker::Address.street_address}, #{Faker::StarWars.planet}"
    })
  i += 1
end

puts 'Creating orders...'
i = 0
while i < 50 do
  Order.create!(
    {
      reference: "BR#{Faker::Number.number(6)}",
      purchase_channel: PurchaseChannel.offset(rand(PurchaseChannel.count)).first,
      client: Client.offset(rand(Client.count)).first,
      delivery_service: DeliveryService.offset(rand(DeliveryService.count)).first,
      total_value: Faker::Commerce.price,
      line_items: [{sku: "case-#{Faker::Hipster.words(3,true,false).join('-').downcase}", model: Faker::Beer.style, case_type: Faker::Pokemon.move}, 
        {sku: "powebank-#{Faker::Pokemon.name.gsub(' ','-').downcase}", capacity: "#{Faker::Number.number(4)}mah"}, 
        {sku: "earphone-#{Faker::StarWars.droid.gsub(' ','-').downcase}", color: Faker::Color.color_name}],
      batch_id: nil
    })
  i += 1
end

puts 'Creating batches...'
PurchaseChannel.all.each do |purchase_channel|
  Batch.create!(
    {
      reference: "P#{Faker::Number.number(6)}",
      status: Batch.statuses.keys[rand(Batch.statuses.size)],
      orders: Order.where(purchase_channel: purchase_channel, batch_id: nil).first(3)
    })
end

puts 'Creating user...'
User.create!([
  {
    name: 'ArtzAdmin',
    email: 'arthurmolina@gmail.com',
    password: '123',
    password_confirmation: '123',
    role: 'admin',
    purchase_channel: PurchaseChannel.offset(rand(PurchaseChannel.count)).first
  },
  {
    name: 'StoreUser',
    email: 'store@example.com',
    password: '123',
    password_confirmation: '123',
    role: 'stores',
    purchase_channel: PurchaseChannel.offset(rand(PurchaseChannel.count)).first
  },
  {
    name: 'ProductionUser',
    email: 'prod@example.com',
    password: '123',
    password_confirmation: '123',
    role: 'admin',
    purchase_channel: PurchaseChannel.offset(rand(PurchaseChannel.count)).first
  },
  {
    name: 'TransportationUser',
    email: 'transportation@example.com',
    password: '123',
    password_confirmation: '123',
    role: 'transportation',
    purchase_channel: PurchaseChannel.offset(rand(PurchaseChannel.count)).first
  }
])