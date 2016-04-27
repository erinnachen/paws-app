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

  def self.ordered
    breeds = where.not(id: 1000).order(name: :asc)
    breeds << Breed.find_or_create_by(id: 1000, name: "Mix")
    breeds << Breed.find_or_create_by(id: 1001, name: "Other")
    breeds << Breed.new(id: 285, name: "Actually a cat")
    breeds << Breed.new(id: 1002, name: "Not a dog")
  end
end
