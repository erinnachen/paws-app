class DogBreed < ActiveRecord::Base
  belongs_to :dog_image
  belongs_to :breed
end
