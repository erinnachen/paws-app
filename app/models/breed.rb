class Breed < ActiveRecord::Base
  has_many :dog_breeds
  has_many :dog_images, through: :dog_breeds

  attr_accessor :accuracy

  def analyzer_accuracy
    (dog_images.where(result: "correct").count*100.0)/(dog_images.where.not(result: nil).count)
  end

  def self.top_breeds_with_count(include_breed, dogist = false)
    if dogist
      breeds = top_breeds_dogist(include_breed)
    else
      breeds = top_breeds(include_breed)
    end
    {breeds: breeds.map(&:name), count: breeds.map(&:image_count)}
  end

  def self.ordered
    breeds = where.not(id: 1000).order(name: :asc)
    breeds << Breed.find_or_create_by(id: 2000, name: "Mix")
    breeds << Breed.find_or_create_by(id: 2001, name: "Other")
    breeds << Breed.new(id: 285, name: "Actually a cat")
    breeds << Breed.new(id: 1002, name: "Not a dog")
  end

  def self.top_breeds_with_accuracy(include_breed, dogist = false)
    if dogist
      breeds = top_breeds_by_accuracy_dogist(include_breed)
    else
      breeds = top_breeds_by_accuracy(include_breed)
    end
    {breeds: breeds.map(&:name), accuracy: breeds.map(&:accuracy)}
  end

  private

    def self.top_breeds(include_breed)
      user = User.find_or_create_by(name: "thedogist")
      top_breeds = self.select("breeds.*, count(dog_breeds.breed_id) AS image_count").joins(:dog_images).group("breeds.id").order('image_count DESC').where.not(dog_images: {user_id: user.id}).first(8)
      if !top_breeds.include?(include_breed) && include_breed
        breed = get_breed(include_breed) unless top_breeds.include?(include_breed)
        top_breeds.pop
        top_breeds << breed
      else
        top_breeds
      end
    end

    def self.top_breeds_dogist(include_breed)
      user = User.find_or_create_by(name: "thedogist")
      top_breeds = self.select("breeds.*, count(dog_breeds.breed_id) AS image_count").joins(:dog_images).group("breeds.id").order('image_count DESC').where(dog_images: {user_id: user.id}).first(8)
      if !top_breeds.include?(include_breed) && include_breed
        breed = get_breed_dogist(include_breed) unless top_breeds.include?(include_breed)
        top_breeds.pop
        top_breeds << breed
      else
        top_breeds
      end
    end

    def self.top_breeds_by_accuracy(include_breed)
      user = User.find_or_create_by(name: "thedogist")
      corrects = self.select("breeds.*, count(result) as correct_count").joins(:dog_images).group("breeds.id").order(id: :asc).where.not(dog_images: {user_id: user.id}).where(dog_images: {result: "correct"})
      totals = self.select("breeds.*, count(result) as total_count").joins(:dog_images).group("breeds.id").order(id: :asc).where.not(dog_images: {user_id: user.id, result: nil})
      totals.sort_by do |breed|
        correct = corrects.find { |breed2| breed.id == breed2.id }
        if correct
          correct = correct.correct_count
        else
          correct = 0
        end
        breed.accuracy = correct*100.0/breed.total_count
        -1*correct*100.0/breed.total_count
      end.first(8)
    end

    def self.top_breeds_by_accuracy_dogist(include_breed)
      user = User.find_or_create_by(name: "thedogist")
      corrects = self.select("breeds.*, count(result) as correct_count").joins(:dog_images).group("breeds.id").order(id: :asc).where(dog_images: {user_id: user.id, result: "correct"})
      totals = self.select("breeds.*, count(result) as total_count").joins(:dog_images).group("breeds.id").order(id: :asc).where(dog_images: {user_id: user.id}).where.not(dog_images: {result: nil})
      totals.sort_by do |breed|
        correct = corrects.find { |breed2| breed.id == breed2.id }
        if correct
          correct = correct.correct_count
        else
          correct = 0
        end
        breed.accuracy = correct*100.0/breed.total_count
        -1*correct*100.0/breed.total_count
      end.first(8)
    end

    def self.get_breed(breed)
      user = User.find_by(name: "thedogist")
      self.select("breeds.*, count(dog_breeds.breed_id) AS image_count").joins(:dog_images).group("breeds.id").order('image_count DESC').where("breeds.id = ? AND dog_images.user_id != ?",breed.id, user.id).first
    end

    def self.get_breed_dogist(breed)
      user = User.find_by(name: "thedogist")
      self.select("breeds.*, count(dog_breeds.breed_id) AS image_count").joins(:dog_images).group("breeds.id").order('image_count DESC').where(id: breed.id).first
    end

end
