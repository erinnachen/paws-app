require "rails_helper"

RSpec.feature "User can login with google oauth" do
  include SpecHelpers
  scenario "see page with paw me button and logout in nav bar" do
    stub_omniauth
    visit '/'
    expect(page).to_not have_link "PAW my puppy!"
    
    click_on "Sign in with Google"

    expect(current_path).to eq "/"
    within(".navbar") do
      expect(page).to have_content "Logged in as Doggie Owner"
      expect(page).to have_content "Logout"
    end

    expect(page).to have_link "PAW my puppy!"
  end
end
