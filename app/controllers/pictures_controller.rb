class PicturesController < ApplicationController
  before_action :authenticate

  def index
    @pictures = PostPicture.order('created_at DESC')
    @new_picture = PostPicture.new
  end

  def create
    @picture = PostPicture.new(picture_params)
    if @picture.save
      flash.now[:notice] = 'All good. Picture was created'
      redirect_to pictures_path
    else
      flash.now[:alert] = 'Something went wrong. Picture wasn\'t created'
      render :index
    end
  end

  def update
    @picture = PostPicture.find(params[:id])
    if @picture.update(picture_params)
      flash.now[:notice] = 'All good. Picture was updated'
      redirect_to pictures_path
    else
      flash.now[:alert] = 'Something went wrong. Picture wasn\'t updated'
      render :index
    end
  end

  def destroy
    @picture = PostPicture.find(params[:id])
    if @picture.destroy
      flash.now[:notice] = 'All good. Picture destroyed'
      redirect_to pictures_path
    else
      flash.now[:alert] = 'Something went wrong. Picture was not deleted.'
      render :index
    end
  end

  private

  def picture_params
    params.require(:post_picture).permit(:caption, :image)
  end
end
