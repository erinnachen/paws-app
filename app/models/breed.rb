class Breed < ActiveRecord::Base
  has_many :dog_breeds
  has_many :dog_images, through: :dog_breeds
end
