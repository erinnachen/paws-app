require 'rails_helper'

RSpec.feature "User sees prediction for analyzer accuracy by breed", type: :feature do
  include SpecHelpers
  scenario "sees the accuracy for the breed" do
    stub_omniauth
    login

    breed = create(:breed, name: "Australian Shepherd")
    image = create(:dog_image, breeds: [breed], result: "correct")
    create(:dog_image, breeds: [breed], result: "correct")
    create(:dog_image, breeds: [breed], result: "wrong")

    visit "dog_images/#{image.id}/report"

    within(".statistics") do
      expect(page).to have_content "PAWs Accuracy for Australian Shepherds: 66.7%"
    end
  end
end
