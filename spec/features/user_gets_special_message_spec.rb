require "rails_helper"

RSpec.feature "User uploads cat image" do
  include SpecHelpers
  scenario "see troll video and message" do
    stub_omniauth
    login
    user = User.find_by(uid: "12789537")
    image = create(:dog_image, image: File.open("#{Rails.root}/spec/support/fixtures/cat.jpg"), user: user, cat: true )

    visit "/dog_images/#{image.id}/analysis"

    expect(page).to have_content "Stop uploading cat images!"
    expect(page).to have_content "I am not a troll!"
    expect(page).to have_css 'iframe[src="https://www.youtube.com/embed/dQw4w9WgXcQ?autoplay=1"]'
  end
end
