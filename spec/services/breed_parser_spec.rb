require 'rails_helper'

RSpec.describe BreedParser, type: :model do
  it "can parse breeds from text" do
    Breed.create(name: "Chihuahua")
    Breed.create(name: "Mix")
    Breed.create(name: "Labrador Retriever")
    Breed.create(name: "Golden Retriever")
    Breed.create(name: "Belgian Malinois")
    Breed.create(name: "Neapolitan Mastiff")
    Breed.create(name: "Pomeranian")
    Breed.create(name: "Irish Wolfhound")
    Breed.create(name: "Maltese Dog")
    Breed.create(name: "German Shepherd")
    Breed.create(name: "Great Dane")
    Breed.create(name: "Miniature Australian Shepherd")
    Breed.create(name: "Toy Poodle")
    Breed.create(name: "Miniature Poodle")
    Breed.create(name: "Standard Poodle")
    Breed.create(name: "Small Münsterländer")

    bp = BreedParser.new

    tweets = File.read(Rails.root.join('spec','support','fixtures','example_tweets.txt')).split("\n")

    tweets.each_with_index do |tweet, ind|
      desc, breed_list = tweet.split(";;").map(&:strip)
      parsed =bp.parse_from_tweet(desc)
      expect(parsed).to eq breed_list
    end
  end
end
