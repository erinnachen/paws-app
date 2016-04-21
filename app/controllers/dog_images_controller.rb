class DogImagesController < ApplicationController
  before_action :require_user
  def new
    @doggie = DogImage.new
  end

  def create
    @doggie = DogImage.new(dog_image_params)
    @doggie.user = current_user
    if @doggie.save
      redirect_to dog_image_path(@doggie)
    else
      flash.now[:danger]= @doggie.errors.full_messages
      render :new
    end
  end

  def show
    @doggie = DogImage.find(params[:id])
  end

  def update
    @doggie = DogImage.find(params[:id])
    @doggie.breeds << Breed.find_or_initialize_by(name: params[:breed])
    if @doggie.save
      head :ok, content_type: "text/json"
    end
  end

  def analysis
    @doggie = DogImage.find(params[:id])
  end

  def report
    @doggie = DogImage.find(params[:id])
  end

  private

    def dog_image_params
      params.require(:dog_image).permit(:image)
    end
end
