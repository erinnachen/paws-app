require "rails_helper"

RSpec.feature "User can logout " do
  include SpecHelpers
  scenario "sees root page" do
    stub_omniauth
    login

    expect(current_path).to eq "/"
    within(".navbar") do
      expect(page).to have_content "Logged in as Doggie Owner"
      expect(page).to have_content "Logout"
    end

    click_on "Logout"
    expect(current_path).to eq "/"

    visit "/dog_images/new"
    expect(current_path).to eq "/"
  end
end
