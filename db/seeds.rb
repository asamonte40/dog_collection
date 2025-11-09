# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# db/seeds.rb
require 'csv'
require 'open-uri'
require 'json'
require 'faker'

# clear existing data
Dog.destroy_all
Owner.destroy_all
Breed.destroy_all


api_uri = "https://dog.ceo/api/breeds/list/all"
api_response = URI.open(api_uri).read
api_data = JSON.parse(api_response)["message"]

# build a list of all API paths
api_paths = []
api_data.each do |main_breed, sub_breeds|
  if sub_breeds.any?
    sub_breeds.each { |sub| api_paths << "#{main_breed}/#{sub}" }
  else
    api_paths << main_breed
  end
end

puts "found #{api_paths.length} breeds in Dog CEO API"
puts "loading breeds from CSV..."

# normalize names for matching
def normalize(name)
  name.to_s.downcase.gsub(/[^a-z]/, '')
end

# fetch image from Dog CEO API
def fetch_dog_image(api_path)
  return nil unless api_path
  response = URI.open("https://dog.ceo/api/breed/#{api_path}/images/random").read
  data = JSON.parse(response)
  data["message"] if data["status"] == "success"
rescue
  nil
end

# find the best API match for a breed
def find_api_match(breed_name, api_paths)
  normalized_name = normalize(breed_name)

  # exact match
  exact_match = api_paths.find { |path| normalize(path) == normalized_name }
  return exact_match if exact_match

  # partial match
  partial_match = api_paths.find do |path|
    normalized_path = normalize(path)
    normalized_name.include?(normalized_path) || normalized_path.include?(normalized_name)
  end
  return partial_match if partial_match

  # first word match (e.g., "Labrador" from "Labrador Retriever")
  first_word = breed_name.split.first.downcase
  api_paths.find { |path| normalize(path).include?(first_word) }
end

# load CSV
csv_path = Rails.root.join("db", "dog_breeds.csv")
csv_data = CSV.read(csv_path, headers: true)

matched = 0
unmatched = []

csv_data.each do |row|
  breed_name = row["Breed"]
  api_path = find_api_match(breed_name, api_paths)

  image_url = api_path ? fetch_dog_image(api_path) : nil
  image_url ||= "https://via.placeholder.com/300?text=#{URI.encode_www_form_component(breed_name)}"

  Breed.find_or_create_by!(name: breed_name) do |breed|
  breed.description = "From #{row['Country of Origin']}. Fur: #{row['Fur Color']}. Height: #{row['Height (in)']} inches. Eye Color: #{row['Color of Eyes']}. Common Health Problems: #{row['Common Health Problems']}"
  breed.temperament = row["Character Traits"] || "Unknown temperament"
  breed.life_span = row["Longevity (yrs)"] ? "#{row['Longevity (yrs)']} years" : "Unknown lifespan"
  breed.image_url = image_url
  end

  if api_path
    matched += 1
  else
    unmatched << breed_name
  end

  puts "created #{breed_name} - image_url: #{image_url}"
end

puts "\n matching results:"
puts "matched: #{matched} breeds"
puts "unmatched: #{unmatched.length} breeds"
if unmatched.any?
  puts "\nbreeds without API images (placeholders used):"
  unmatched.first(10).each { |name| puts "  - #{name}" }
  puts "  ... and #{unmatched.length - 10} more" if unmatched.length > 10
end

puts "\ncreating owners..."
10.times do
  Owner.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.unique.email,
    address: Faker::Address.full_address
  )
end

puts "creating dogs..."
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

  puts "#{Breed.count} Breeds, #{Owner.count} Owners, #{Dog.count} Dogs created."
