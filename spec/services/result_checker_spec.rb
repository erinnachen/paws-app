require 'rails_helper'

RSpec.describe ResultChecker, type: :model do
  it "matches the guessed breed with a single possibility match" do
    breed = Breed.create(name: "Pug")
    possibilities = "pug"
    guessed_breed = breed
    result, breeds = ResultChecker.get_breeds(guessed_breed, possibilities)
    expect(result).to eq "correct"
    expect(breeds).to eq [breed]
  end

  it "does not match if there is a single incorrect possibility" do
    breed = Breed.create(name: "Pug")
    breed2 = Breed.create(name: "Australian Shepherd")
    possibilities = "australian shepherd"
    guessed_breed = breed
    result, breeds = ResultChecker.get_breeds(guessed_breed, possibilities)
    expect(result).to eq "wrong"
    expect(breeds).to eq [breed2]
  end

  it "matches for multiple possibilities" do
    breed = Breed.create(name: "Pug")
    possibilities = "australian shepherd, pug"
    guessed_breed = breed
    result, breeds = ResultChecker.get_breeds(guessed_breed, possibilities)
    expect(result).to eq "correct"
    expect(breeds).to eq [breed]
  end

  it "returns multiple breeds if the possibilities include mix" do
    breed = Breed.create(name: "Pug")
    breed2 = Breed.create(name: "Mix")
    breed3 = Breed.create(name: "Australian Shepherd")
    possibilities = "mix, australian shepherd, pug"
    guessed_breed = breed
    result, breeds = ResultChecker.get_breeds(guessed_breed, possibilities)
    expect(result).to eq "correct"
    expect(breeds).to eq [breed2, breed3, breed]
  end

  it "returns wrong but all possibilities" do
    breed = Breed.create(name: "Pug")
    breed2 = Breed.create(name: "Australian Shepherd")
    breed3 = Breed.create(name: "German Shepherd")
    possibilities = "australian shepherd, pug"
    guessed_breed = breed3
    result, breeds = ResultChecker.get_breeds(guessed_breed, possibilities)
    expect(result).to eq "wrong"
    expect(breeds).to eq [breed2, breed]
  end

end
