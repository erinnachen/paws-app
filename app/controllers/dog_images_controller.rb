class DogImagesController < ApplicationController
  before_action :require_user
  def new
    @doggie = DogImage.new
  end

  def create
    @doggie = DogImage.new(dog_image_params)
    @doggie.user = current_user
    if @doggie.save
      flash[:success]= "Your puppy is being PAWed"
      redirect_to dog_image_path(@doggie)
    else
      flash.now[:danger]= @doggie.errors.full_messages
      render :new
    end
  end

  def show
    @doggie = DogImage.find(params[:id])
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
