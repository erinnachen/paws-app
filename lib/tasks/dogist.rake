namespace :dogist do
  desc "Build a base of dogist breeds"
  task get_initial_images: :environment do
    dogist = User.find_or_create_by(name: "thedogist")
    di_analyzer = DogistImageAnalyzer.new
    bp = BreedParser.new
    twitter = TwitterService.new

    max_id = 725107899756888064
    16.times do |count|
      tweets_info = twitter.get_dogist_tweets(max_id)
      tweets_info.each_with_index do |tweet, ind|
        begin
          puts "Tweet ##{ind} in batch #{count} with ID: #{tweet[:id]} Created at: #{tweet[:created_at]}"
          puts "Dogist description: #{tweet[:text]}"
          dog_image = di_analyzer.create_image_from_tweet(tweet, dogist)
          puts "Dog image ID: #{dog_image.id} created, with result: #{dog_image.result}, Image breeds: #{dog_image.breeds.map(&:name).join(", ")}"
          puts
        rescue Exception => e
          puts "Tweet ##{ind} had an error"
        end
      end
      max_id = tweets_info.last[:id].to_i
    end
  end
end
