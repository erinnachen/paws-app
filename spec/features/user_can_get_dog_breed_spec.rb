require "rails_helper"

RSpec.feature "User can get a dog bread" do
  include SpecHelpers
  scenario "see page with image displayed" do
    stub_omniauth
    login
    user = User.find_by(uid: "12789537")
    breed = create(:breed, name: "Australian Shepherd")
    image = create(:dog_image, breeds: [breed], user_id: user.id)

    visit "/dog_images/#{image.id}/analysis"

    expect(page).to have_content "Australian Shepherd"
  end
end
