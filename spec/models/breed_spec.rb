require 'rails_helper'

RSpec.describe Breed, type: :model do
  it {should have_many(:dog_images).through(:dog_breeds)}
end
