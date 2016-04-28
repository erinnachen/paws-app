class DogImagesController < ApplicationController
  before_action :require_user

  def new
    @doggie = DogImage.new
  end

  def create
    @doggie = current_user.dog_images.new(dog_image_params)
    if @doggie.save
      redirect_to dog_image_path(@doggie)
    else
      flash.now[:danger]= "Please add an image to the page"
      render :new
    end
  end

  def show
    @doggie = current_user.dog_images.find(params[:id])
  end

  def update
    @doggie = current_user.dog_images.find(params[:id])
    process_breed_info
    if @doggie.save
      head :ok, content_type: "text/json"
    end
  end

  def update_result
    @doggie = DogImage.find(params[:id])
    @doggie.update(result: params[:result])
    redirect_to report_dog_image_path(@doggie.id)
  end

  def update_wrong_result
    @doggie = DogImage.find(params[:id])
    if params[:dog_image][:breeds].to_i == 285 && !@doggie.cat
      @doggie.update(result: "wrong", cat: true)
      redirect_to analysis_dog_image_path(@doggie.id) and return
    elsif params[:dog_image][:breeds].to_i == 285
      @doggie.update(result: "correct")
      redirect_to analysis_dog_image_path(@doggie.id) and return
    elsif !@doggie.breeds.first || @doggie.breeds.first.id != params[:dog_image][:breeds].to_i
      @doggie.update(result: "wrong")
      flash[:alert] = "SOOOO SOOO0 SORRY for the troll video" if @doggie.cat
      @doggie.cat = false
      @doggie.dog_breeds.destroy_all
      @doggie.breeds << Breed.find(params[:dog_image][:breeds].to_i)
      @doggie.save
    else
      @doggie.update(result: "correct")
    end
    redirect_to report_dog_image_path(@doggie.id)
  end

  def analysis
    @doggie = current_user.dog_images.find(params[:id])
  end

  def report
    @doggie = current_user.dog_images.find(params[:id])
    @top_breeds = Breed.top_breeds(@doggie.breeds.first)
    @top_breeds_by_accuracy = Breed.top_breeds_by_accuracy(@doggie.breeds.first)
    if @doggie.cat?
      redirect_to analysis_dog_image_path(@doggie.id)
    end
  end

  private

    def dog_image_params
      params.require(:dog_image).permit(:image)
    end

    def process_breed_info
      breed = Breed.find_by(id: params[:breed_id])
      @doggie.breeds << breed if breed
      if params[:breed_id].to_i > 280 && params[:breed_id].to_i < 294
        @doggie.update(cat: true)
      end
    end
end
