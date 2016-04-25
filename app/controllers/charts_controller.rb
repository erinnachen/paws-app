class ChartsController < ApplicationController
  respond_to :json

  def top_breeds
    @doggie = DogImage.find(params[:id])
    @top_breeds = Breed.top_breeds_with_count(@doggie.breeds.first)
    respond_with @top_breeds
  end

end
