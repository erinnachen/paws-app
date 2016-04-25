class Breed < ActiveRecord::Base
  has_many :dog_breeds
  has_many :dog_images, through: :dog_breeds

  def analyzer_accuracy
    (dog_images.where(result: "correct").count*100.0)/(dog_images.where.not(result: nil).count)
  end

  def self.top_breeds(include_breed)
    top_breeds = self.select("breeds.*, count(dog_breeds.dog_image_id) AS image_count").joins(:dog_breeds).group("breeds.id").order('image_count DESC').first(8)
    if !top_breeds.include?(include_breed) && include_breed
      breed = get_breed(include_breed) unless top_breeds.include?(include_breed)
      top_breeds.pop
      top_breeds << breed
    else
      top_breeds
    end
  end

  def self.get_breed(breed)
    self.select("breeds.*, count(dog_breeds.dog_image_id) AS image_count").joins(:dog_breeds).group("breeds.id").order('image_count DESC').where(id: breed.id).first
  end

  def self.top_breeds_with_count(include_breed)
    breeds = top_breeds(include_breed)
    {breeds: breeds.map(&:name), count: breeds.map(&:image_count)}
  end
end
