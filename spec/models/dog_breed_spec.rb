require 'rails_helper'

RSpec.describe DogBreed, type: :model do
  it {should belong_to :dog_image}
  it {should belong_to :breed}
end
