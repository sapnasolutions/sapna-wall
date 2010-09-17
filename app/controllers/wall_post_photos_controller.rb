class WallPostPhotosController < ApplicationController
  skip_before_filter :save_return_to_url
  skip_before_filter :verify_authenticity_token, :only => :create
  layout false

  def show
    @wall_photo = WallPhoto.find(params[:id])
  end

  def create
    @wall_post_photo = WallPostPhoto.new(:uploaded_data => params["Filedata"])
    @wall_post_photo.user_id = params[:user_id]
    @wall_post_photo.save
    logger.debug "======================================="
    logger.debug @wall_post_photo.errors.full_messages
    logger.debug "======================================="
  end

  def destroy
    WallPostPhoto.delete_all(["user_id = ? AND wall_post_id is null", current_user.id])
    render :nothing => true
  end


end
