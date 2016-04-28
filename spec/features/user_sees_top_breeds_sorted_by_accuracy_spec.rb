require 'rails_helper'

RSpec.feature "User sees a histogram of most seen breeds", type: :feature do
  include SpecHelpers
  scenario "sees the breed image in the report" do
    stub_omniauth
    login
    user = User.find_by(uid: "12789537")

    breeds = []
    breed = create(:breed, name: "Australian Shepherd")
    breed2 = create(:breed, name: "Chihuahua")
    image = create(:dog_image, breeds: [breed], result: "correct", user: user)
    create(:dog_image, breeds: [breed], result: "correct", user: user)
    create(:dog_image, breeds: [breed], result: "wrong", user: user)
    create(:dog_image, breeds: [breed2], result: "wrong", user: user)
    create(:dog_image, breeds: [breed2], result: "correct", user: user)
    create(:dog_image, breeds: [breed2], result: "wrong", user: user)

    visit "/dog_images/#{image.id}/report"

    within(".status") do
      expect(page).to have_content "Breed: Australian Shepherd"
      expect(page).to have_content "PAWs was correct"
    end

    within(".accuracy") do
      expect(first("li")).to have_content ("Australian Shepherd -- Accuracy: 66.7 %")
      expect(page).to have_content ("Australian Shepherd -- Accuracy: 66.7 %")
      expect(page).to have_content ("Chihuahua -- Accuracy: 33.3 %")
    end
  end
end
