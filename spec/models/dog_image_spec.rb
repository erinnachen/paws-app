require 'rails_helper'

RSpec.describe DogImage, type: :model do
  it {should belong_to :user}
  it {should have_many(:breeds).through(:dog_breeds)}
end
