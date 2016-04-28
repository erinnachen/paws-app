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
      flash.now[:danger]= "Please add an image to analyze!!!"
      render :new
    end
  end

  def show
    @doggie = current_user.dog_images.find(params[:id])
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
    elsif params[:dog_image][:breeds].to_i == 285 && @doggie.cat
      @doggie.update(result: "correct")
      redirect_to analysis_dog_image_path(@doggie.id) and return
    elsif @doggie.cat && params[:dog_image][:breeds].to_i != 285 && params[:dog_image][:breeds].to_i != 1002 #
      flash[:alert] = "SOOOO SOOO0 SORRY for the troll video" if @doggie.cat
      @doggie.cat = false
      @doggie.update(result: "wrong")
      @doggie.dog_breeds.destroy_all
      @doggie.breeds << Breed.find(params[:dog_image][:breeds].to_i)
      @doggie.save
    elsif params[:dog_image][:breeds].to_i == 1002 && @doggie.breeds.empty?
      @doggie.update(result: "correct")
    elsif params[:dog_image][:breeds].to_i == 1002
      @doggie.dog_breeds.destroy_all
      @doggie.update(result: "wrong")
    else
      @doggie.update(result: "wrong")
      @doggie.dog_breeds.destroy_all
      @doggie.breeds << Breed.find(params[:dog_image][:breeds].to_i)
      @doggie.save
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
      if params[:dog_image]
        params.require(:dog_image).permit(:image)
      else
        {}
      end
    end
end
