# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'csv'
require 'open-uri'
require 'json'
require 'faker'


Dog.destroy_all
Owner.destroy_all
Breed.destroy_all

# create owners (faker)
10.times do
  Owner.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.unique.email,
    address: Faker::Address.full_address
  )
end

# fetching dog breed
dog_ceo_data = JSON.parse(URI.open('https://dog.ceo/api/breeds/list/all').read)['message']

# read csv data
csv_data = CSV.read(Rails.root.join('db', 'dog_breeds.csv'), headers: true)

# combining data source
dog_ceo_data.each_key do |api_breed|
  csv_match = csv_data.find do |row|
    breed_name = row['breed']
    breed_name && breed_name.downcase.include?(api_breed.downcase)
  end


  begin
    image_url = JSON.parse(URI.open("https://dog.ceo/api/breed/#{api_breed}/images/random").read)['message']
  rescue
    image_url = nil
  end

  Breed.create!(
    name: api_breed.capitalize,
    description: csv_match ? csv_match['description'] : "A wonderful #{api_breed} breed.",
    temperament: csv_match ? csv_match['temperament'] : "Friendly and loyal",
    life_span: csv_match ? csv_match['life_span'] : "Unknown",
    image_url: image_url
  )
end

# create dogs
200.times do
  breed = Breed.order("RANDOM()").first
  owner = Owner.order("RANDOM()").first

  Dog.create!(
    name: Faker::Creature::Dog.name,
    image_url: breed.image_url,
    breed: breed,
    owner: owner
  )
end

puts "#{Owner.count} Owners, #{Breed.count} Breeds, #{Dog.count} Dogs."
