namespace :dogist do
  desc "Build a base of dogist images"
  task get_initial_images: :environment do
    dogist = User.find_or_create_by(name: "thedogist")
    twitter = TwitterService.new
    parser = BreedParser.new
    tweets_info = twitter.get_dogist_tweets
    tweets_info.each do |tweet|
      begin
        image_url = tweet[:entities][:media].first[:media_url]
        response = Faraday.get("http://localhost:5000/api/v1/dog_image_categories?image=#{image_url}")
        breed_id = JSON.parse(response.body)["breed_id"]
        guessed_breed = Breed.find_by(id: breed_id)
        puts "Guessed: #{guessed_breed.name}" if guessed_breed
        puts "Dogist description: #{tweet[:text]}"
        puts "------------------------------------------------------------------"
        dogist_breeds = parser.parse_from_tweet(tweet[:text])
        result = ResultChecker.check(guessed_breed, dogist_breeds) if guessed_breed
        DogImage.create(user: dogist, image: image_url, breeds: dogist_breeds, result: result)
      rescue Exception => e
        puts e.message
        puts e.backtrace.inspect
      end
    end
  end
end
