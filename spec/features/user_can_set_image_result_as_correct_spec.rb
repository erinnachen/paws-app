require 'rails_helper'

RSpec.feature "User sets image result to correct", type: :feature do
  include SpecHelpers
  scenario "sees the accuracy for the breed" do
    user = User.create(uid: "133121", name: "Tom")
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    user2 = User.create(uid: "11111", name: "Janey")

    breed = create(:breed, name: "Australian Shepherd")
    image = create(:dog_image, breeds: [breed], user_id: user.id)
    create(:dog_image, breeds: [breed], result: "correct", user_id: user.id)
    create(:dog_image, breeds: [breed], result: "wrong", user_id: user2.id)
    create(:dog_image, breeds: [breed], user_id: user2.id)

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
