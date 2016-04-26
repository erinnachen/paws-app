require 'rails_helper'

RSpec.describe DogImage, type: :model do
  it {should belong_to :user}
  it {should validate_presence_of :user}
  it {should have_many(:breeds).through(:dog_breeds)}
  it {should validate_inclusion_of(:result).in_array([nil, "correct", "wrong"])}
end
