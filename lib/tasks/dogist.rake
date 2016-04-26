namespace :dogist do
  desc "Build a base of dogist images"
  task get_initial_images: :environment do
    dt = User.find_by(name: "thedogist")
    twitter = TwitterService.new
    tweets_info = twitter.get_dogist_tweets
    #for each tweet in tweets_json
    tweets_info.each do |tweet|
      begin
        image_url = tweet[:entities][:media].first[:media_url]
        response = Faraday.get("http://localhost:5000/api/v1/dog_image_categories?image=#{image_url}")
        breed_id = JSON.parse(response.body)["breed_id"]
        guessed_breed = Breed.find_by(id: breed_id)
      # Build a dog image object associated with the dogist
      # get the image analyzed
      # see if the breed returned looks like the breed involved
      # If so, set the breed and result ==  correct
      # Otherwise, figure out what breed this dog is. and set the result == wrong
        puts "Guessed: #{guessed_breed.name}" if guessed_breed
        puts "Dogist description: #{tweet[:text]}"
        puts "------------------------------------------------------------------"
      rescue Exception => e
        puts e.message
        puts e.backtrace.inspect
      end
    end
  end
end
