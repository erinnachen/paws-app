require 'rails_helper'

RSpec.feature "User sees a histogram of most seen breeds", type: :feature do
  include SpecHelpers
  scenario "sees the breed image in the report" do
    stub_omniauth
    login

    breeds = []
    8.times { breeds << create(:breed) }
    breed = create(:breed, name: "Australian Shepherd")
    image = create(:dog_image, breeds: [breed], result: "correct")
    nimages = [5,4,2,6,3,4,5,3]
    breeds.each_with_index do |db, ind|
      nimages[ind].times do
        create(:dog_image, breeds: [db], result: "correct")
      end
    end

    visit "/dog_images/#{image.id}/report"

    within(".status") do
      expect(page).to have_content "Breed: Australian Shepherd"
      expect(page).to have_content "PAWs was correct"
    end

    #wait_for_ajax

    within("#top-breeds-analyzed") do
      expect(first("li")).to have_content ("Breed 4 -- Count: 6")
      expect(page).to have_content ("Breed 4 -- Count: 6")
      expect(page).to have_content ("Australian Shepherd -- Count: 1")
      expect(page).to_not have_content("Breed 3 -- Count: 2")
    end
  end
end
