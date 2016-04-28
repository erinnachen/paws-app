require "rails_helper"

RSpec.describe "GET /api/v1/charts/top_breeds/:id" do
  include SpecHelpers
  it "returns 8 breeds by count" do
    user = User.create(uid: "12789537")
    breeds = []
    8.times { breeds << create(:breed) }
    breed = create(:breed, name: "Australian Shepherd")
    image = create(:dog_image, breeds: [breed], result: "correct", user: user)
    nimages = [5,4,2,6,3,4,5,3]
    breeds.each_with_index do |db, ind|
      nimages[ind].times do
        create(:dog_image, breeds: [db], result: "correct", user: user)
      end
    end

    get "/api/v1/charts/top_breeds/#{image.id}"
    expect(response.status).to eq 200

  end
end
