require 'rails_helper'

RSpec.describe DogistImageAnalyzer, type: :model do
  it "can take dogist tweets and build an image" do
    VCR.use_cassette "dogist#simple example" do
      Breed.create(id: 1200, name: "Heeler")
      Breed.create(id: 1000, name: "Mix")
      Breed.create(id: 151, name: "Chihuahua")

      dogist = User.create(name: "thedogist")
      di_analyzer = DogistImageAnalyzer.new
      tweet = {created_at: "Tue Apr 26 23:42:49 +0000 2016",
               id: 725107899756888064,
               text: "Spacedog, Heeler mix (1), 58th &amp; 5th Ave., New York, NY • \"He's from @AnimalLeague. He's a superdog.\" https://t.co/f1sFgTfVBJ",
               entities:  {media:
                [{media_url:"http://pbs.twimg.com/media/ChAZyGFWUAQrljO.jpg"}]}
              }

      dog_image = di_analyzer.create_image_from_tweet(tweet, dogist)
      expect(dog_image).to be_kind_of DogImage
      expect(dog_image.user).to eq dogist
      expect(dog_image.result).to eq "wrong"
      expect(dog_image.breeds.map(&:name)).to eq ["Mix", "Heeler"]
    end
  end
end
