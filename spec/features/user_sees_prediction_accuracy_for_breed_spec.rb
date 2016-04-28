require 'rails_helper'

RSpec.feature "User sees prediction for analyzer accuracy by breed", type: :feature do
  include SpecHelpers
  scenario "sees the accuracy for the breed" do
    stub_omniauth
    login
    user = User.find_by(uid: "12789537")

    breed = create(:breed, name: "Australian Shepherd")
    image = create(:dog_image, breeds: [breed], result: "correct", user: user)
    create(:dog_image, breeds: [breed], result: "correct", user: user)
    create(:dog_image, breeds: [breed], result: "wrong", user: user)

    visit "dog_images/#{image.id}/report"

    within(".status") do
      expect(page).to have_content "PAWs Accuracy for Australian Shepherds: 66.7%"
    end
  end
end
