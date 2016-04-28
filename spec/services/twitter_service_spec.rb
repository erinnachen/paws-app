require 'rails_helper'

RSpec.describe TwitterService, type: :model do
  it "can get dogist tweets from the most recent" do
    VCR.use_cassette "twitter_service#dogist_most_recent" do
      ts = TwitterService.new
      tweets_info = ts.get_dogist_tweets
      tweet = tweets_info[4]

      expect(tweets_info.count).to eq 189
      expect(tweet[:id]).to eq 725107899756888064
      expect(tweet[:text]).to eq "Spacedog, Heeler mix (1), 58th &amp; 5th Ave., New York, NY • \"He's from @AnimalLeague. He's a superdog.\" https://t.co/f1sFgTfVBJ"
      expect(tweet[:created_at]).to eq "Tue Apr 26 23:42:49 +0000 2016"
      expect(tweet[:entities][:media].first[:media_url]).to eq "http://pbs.twimg.com/media/ChAZyGFWUAQrljO.jpg"
    end
  end

  it "can get dogist tweets older than max id" do
    VCR.use_cassette "twitter_service#dogist_in_the_past" do
      ts = TwitterService.new
      tweets_info = ts.get_dogist_tweets(712028938697121792)
      tweet = tweets_info[4]

      expect(tweets_info.count).to eq 191
      expect(tweet[:id]).to eq 711601324161417216
      expect(tweet[:text]).to eq "Libby, French Bulldog (5 m/o), WSP, NYC • \"She hates walking. She'll sit there and look at me, like, 'Make me.'.\" https://t.co/8mlc9LVV3O"
      expect(tweet[:created_at]).to eq "Sun Mar 20 17:12:31 +0000 2016"
      expect(tweet[:entities][:media].first[:media_url]).to eq "http://pbs.twimg.com/media/CeAdnUwXEAAF_sB.jpg"

      tweets_info.each do |tweet|
        expect(tweet[:id]).to be <= 712028938697121792
      end
    end
  end
end
