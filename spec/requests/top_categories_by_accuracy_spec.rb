require "rails_helper"

RSpec.describe "GET /api/v1/charts/top_breeds_by_accuracy/:id" do
  include SpecHelpers
  it "returns 8 breeds by count" do
    user = User.create(uid: "12789537")
    breed1 = create(:breed, name: "Australian Shepherd")
    image = create(:dog_image, breeds: [breed1], result: "correct", user: user)
    create(:dog_image, breeds: [breed1], result: "correct", user: user)
    breed2 = create(:breed, name: "Doberman Pinscher")
    create(:dog_image, breeds: [breed2], result: "correct", user: user)
    create(:dog_image, breeds: [breed2], result: "wrong", user: user)


    get "/api/v1/charts/top_breeds_by_accuracy/#{image.id}"
    breeds_info = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq 200
    expect(breeds_info[:breeds].first).to eq "Australian Shepherd"
    expect(breeds_info[:accuracy].last).to eq 50.0
  end
end
