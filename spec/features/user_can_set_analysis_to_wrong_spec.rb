require 'rails_helper'

RSpec.feature "User sets image result to wrong", type: :feature do
  include SpecHelpers
  context "changes breed" do
    scenario "sees the accuracy for the new breed" do
      stub_omniauth
      login
      user = User.find_by(uid: "12789537")
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      user2 = User.create(uid: "11111", name: "Janey")

      create(:breed, name: "German Shepherd")
      breed = create(:breed, name: "Australian Shepherd")
      breed2 = create(:breed, name: "Chihuahua")
      image = create(:dog_image, breeds: [breed], user: user, id: 101)
      create(:dog_image, breeds: [breed2], result: "correct", user: user)
      create(:dog_image, breeds: [breed2], result: "wrong", user: user2)
      create(:dog_image, breeds: [breed], user: user2)

      visit "/dog_images/101/analysis"
      expect(page).to have_content "PAWs believes your doggie is a: Australian Shepherd"

      within("option:first") do
        expect(page).to have_content("Australian Shepherd")
      end

      select 'Chihuahua', from: "dog_image[breeds]"
      click_on "Update dog data"

      expect(current_path).to eq "/dog_images/101/report"
      within(".status") do
        expect(page).to have_content "Breed: Chihuahua"
        expect(page).to have_content "PAWs was wrong"
        expect(page).to have_content "PAWs Accuracy for Chihuahuas: 33.3%"
      end
    end
  end

  context "does not change the breed after clicking update" do
    scenario "sees the accuracy for the original breed" do
      stub_omniauth
      login
      user = User.find_by(uid: "12789537")
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      user2 = User.create(uid: "11111", name: "Janey")

      create(:breed, name: "German Shepherd")
      create(:breed, name: "Chihuahua")
      breed = create(:breed, name: "Australian Shepherd")
      image = create(:dog_image, breeds: [breed], user: user, id: 101)
      create(:dog_image, breeds: [breed], result: "wrong", user: user2)
      create(:dog_image, breeds: [breed], result: "correct", user: user2)

      visit "/dog_images/101/analysis"
      expect(page).to have_content "PAWs believes your doggie is a: Australian Shepherd"

      within("option:first") do
        expect(page).to have_content("Australian Shepherd")
      end

      select 'Australian Shepherd', from: "dog_image[breeds]"
      click_on "Update dog data"

      expect(current_path).to eq "/dog_images/101/report"
      within(".status") do
        expect(page).to have_content "Breed: Australian Shepherd"
        expect(page).to have_content "PAWs was correct"
        expect(page).to have_content "PAWs Accuracy for Australian Shepherds: 66.7%"
      end
    end
  end
end
