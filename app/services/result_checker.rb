class ResultChecker
  def self.get_breeds(guessed, breed_list)
    possibilities = breed_list.split(",").map(&:strip)
    match = possibilities.find { |breed| guessed.name.downcase == breed }
    if match && !breed_list.include?("mix")
      ["correct", [Breed.where("lower(name) = ?", match).first]]
    elsif match && breed_list.include?("mix")
      ["correct", possibilities.map {|breed| Breed.where("lower(name) = ?", breed).first}]
    else
      ["wrong", possibilities.map {|breed| Breed.where("lower(name) = ?", breed).first}]
    end
  end
end
