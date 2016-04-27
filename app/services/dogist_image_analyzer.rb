class DogistImageAnalyzer
  def initialize
    @_conn = Faraday.new(:url => 'http://localhost:5000') do |faraday|
      faraday.request  :url_encoded
      faraday.response :logger
      faraday.adapter  Faraday.default_adapter
    end
    @_bp = BreedParser.new
  end


  def create_image_from_tweet(tweet, user)
    image_url = tweet[:entities][:media].first[:media_url]
    guessed_breed = analyze_image(image_url)
    possibilities = bp.parse_from_tweet(tweet[:text])
    result, breeds = ResultChecker.get_breeds(guessed_breed, possibilities)

    di = DogImage.create(user: user, breeds: breeds, image: image_url, result: result)
  end


  private
    def conn
      @_conn
    end

    def bp
      @_bp
    end

    def get_analysis(image_url)
      response = conn.get do |req|
        req.url '/api/v1/dog_image_categories'
        req.params['image'] = image_url
      end
      JSON.parse(response.body, symbolize_names: true)
    end

    def analyze_image(image_url)
      breed_id = get_analysis(image_url)[:breed_id]
      Breed.find_by(id: breed_id)
    end
end
