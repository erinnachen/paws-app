class Api::V1::DogImagesController < Api::V1::BaseController
  respond_to :json

  def update
    @doggie = DogImage.find(params[:id])
    process_breed_info
    respond_with @doggie
  end

  private
    def process_breed_info
      breed = Breed.find_by(id: params[:breed_id])
      @doggie.breeds << breed if breed
      if params[:breed_id].to_i > 280 && params[:breed_id].to_i < 294
        @doggie.update(cat: true)
      end
    end
end
