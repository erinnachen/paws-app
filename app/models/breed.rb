class Breed < ActiveRecord::Base
  has_many :dog_breeds
  has_many :dog_images, through: :dog_breeds

  def analyzer_accuracy
    (dog_images.where(result: "correct").count*100.0)/(dog_images.count)
  end
end
