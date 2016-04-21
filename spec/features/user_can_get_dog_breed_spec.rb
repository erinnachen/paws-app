require "rails_helper"

RSpec.feature "User can get a dog bread" do
  include SpecHelpers
  scenario "see page with image displayed" do
    stub_omniauth
    visit '/'
    click_on "Sign in with Google"
    breed = create(:breed, name: "Australian Shepherd")
    image = create(:dog_image, breeds: [breed])

    visit "/dog_images/#{image.id}/analysis"

    expect(page).to have_content "Australian Shepherd"
  end
end
