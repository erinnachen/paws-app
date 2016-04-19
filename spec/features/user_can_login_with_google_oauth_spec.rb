require "rails_helper"

RSpec.feature "User can login with google oauth" do
  scenario "see page with paw me button and logout in nav bar" do
    visit '/'
    click_on "Sign in with Google"

    expect(current_page).to eq "/"
    within(".navbar") do
      expect(page).to have_content "Logged in as Doggie Owner"
      expect(page).to have_content "Logout"
    end

    expect(page).to have_button "PAW my puppy!"
  end
end
