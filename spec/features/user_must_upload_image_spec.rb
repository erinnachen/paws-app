require "rails_helper"

RSpec.feature "User can upload an image" do
  include SpecHelpers
  context "submit image" do
    scenario "see the waiting page" do
      stub_omniauth
      visit '/'
      click_on "Sign in with Google"
      click_on "PAW my puppy!"

      click_on "Analyze image"

      expect(page).to have_content "Please add an image to analyze!!!"
    end
  end
end
