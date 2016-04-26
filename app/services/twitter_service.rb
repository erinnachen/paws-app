class TwitterService
  def initialize
    @_conn = Faraday.new(:url => 'https://api.twitter.com') do |faraday|
      faraday.request  :url_encoded
      faraday.response :logger
      faraday.adapter  Faraday.default_adapter
    end
  end

  def get_dogist_tweets(max_id = nil)
    response = conn.get do |req|
      req.url '/1.1/statuses/user_timeline.json'
      req.headers["Authorization"] = "Bearer #{ENV["TWITTER_BEARER"]}"
      req.params['screen_name'] = "thedogist"
      req.params['count'] = 200
      req.params['max_id'] = max_id if max_id
      req.params['include_rts'] = "false"
    end
    JSON.parse(response.body, symbolize_names: true)
  end


  private

    def conn
      @_conn
    end
end
