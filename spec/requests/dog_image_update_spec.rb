require "rails_helper"

RSpec.describe "PATCH /api/v1/dog_images/:id" do
  include SpecHelpers
  it "returns 8 breeds by count" do
    user = User.create(uid: "12789537")
    breed = create(:breed, name: "Australian Shepherd")
    image = create(:dog_image, breeds: [breed], result: "correct", user: user)

    patch "/api/v1/dog_images/#{image.id}", {breed_id: breed.id}
    expect(response.status).to eq 204
    image2 = DogImage.find(image.id)
    expect(image2.breeds.first.name).to eq "Australian Shepherd"
  end
end
