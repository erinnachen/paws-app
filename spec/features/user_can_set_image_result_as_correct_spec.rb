require 'rails_helper'

RSpec.feature "User sets image result to correct", type: :feature do
  include SpecHelpers
  scenario "sees the accuracy for the breed" do
    stub_omniauth
    login
    user = User.find_by(uid: "12789537")
    user2 = User.create(uid: "11111", name: "Janey")

    breed = create(:breed, name: "Australian Shepherd")
    image = create(:dog_image, breeds: [breed], user: user)
    create(:dog_image, breeds: [breed], result: "correct", user: user)
    create(:dog_image, breeds: [breed], result: "wrong", user: user2)
    create(:dog_image, breeds: [breed], user: user2)

    visit "/dog_images/#{image.id}/analysis"
    expect(page).to have_content "PAWs believes your doggie is a: Australian Shepherd"
    click_on "How did you know?!"

    expect(current_path).to eq "/dog_images/#{image.id}/report"
    within(".status") do
      expect(page).to have_content "Breed: Australian Shepherd"
      expect(page).to have_content "PAWs was correct"
    end

    within(".statistics") do
      expect(page).to have_content "PAWs Accuracy for Australian Shepherds: 66.7%"
    end
  end
end
