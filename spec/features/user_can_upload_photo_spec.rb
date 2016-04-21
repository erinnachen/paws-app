require "rails_helper"

RSpec.feature "User can upload an image" do
  include SpecHelpers
  scenario "see page with image displayed" do
    stub_omniauth
    visit '/'
    click_on "Sign in with Google"
    click_on "PAW my puppy!"

    expect(current_path).to eq "/dog_images/new"

    expect(page).to have_button "Analyze image"
  end
end
