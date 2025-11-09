require "test_helper"

class BreedsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get breeds_url
    assert_response :success
  end

  test "should get show" do
    breed = Breed.create!(
    name: "Test Breed",
    description: "A sample test breed.",
    temperament: "Friendly",
    life_span: "10-12 years",
    image_url: "https://placehold.co/300x300?text=Test+Breed"
  )
  get breed_url(breed)
  assert_response :success
  end
end
