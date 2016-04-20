require "rails_helper"

RSpec.feature "User can upload an image" do
  include SpecHelpers
  scenario "see page with image displayed" do
    stub_omniauth
    visit '/'
    click_on "Sign in with Google"
    click_on "PAW my puppy!"

    expect(current_path).to eq "/uploads/new"
    click_on "Add image"
    click_on "Analyze image"
  end
end
