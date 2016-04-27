require 'rails_helper'

RSpec.feature "User sets cat result to wrong", type: :feature do
  include SpecHelpers
  context "changes breed" do
    scenario "sees the accuracy for the new breed" do
      stub_omniauth
      login
      user = User.find_by(uid: "12789537")
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      create(:breed, name: "German Shepherd")
      breed = create(:breed, name: "Australian Shepherd")
      breed2 = create(:breed, name: "Chihuahua")
      image = create(:dog_image, user_id: user.id, id: 101, cat: true)

      visit "/dog_images/101/analysis"
      expect(page).to have_content "Stop uploading cat images!"

      click_on "I am not a troll!"
      select 'Chihuahua', from: "dog_image[breeds]"
      click_on "Update dog data"

      expect(current_path).to eq "/dog_images/101/report"

      expect(page).to have_content "SOOOO SOOO0 SORRY for the troll video"
      within(".status") do
        expect(page).to have_content "Breed: Chihuahua"
        expect(page).to have_content "PAWs was wrong"
      end

      within(".statistics") do
        expect(page).to have_content "PAWs Accuracy for Chihuahuas: 0.0%"
      end
    end
  end

  context "sets breed to cat" do
    scenario "sees the analysis page without the change data button" do
      stub_omniauth
      login
      user = User.find_by(uid: "12789537")
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      create(:breed, name: "German Shepherd")
      breed = create(:breed, name: "Australian Shepherd")
      breed2 = create(:breed, name: "Chihuahua")
      image = create(:dog_image, user_id: user.id, id: 101, cat: true)

      visit "/dog_images/101/analysis"
      expect(page).to have_content "Stop uploading cat images!"

      click_on "I am not a troll!"
      select 'Actually a cat', from: "dog_image[breeds]"
      click_on "Update dog data"

      expect(current_path).to eq "/dog_images/101/analysis"
      expect(page).to_not have_button "Update dog data"
    end
  end
end
