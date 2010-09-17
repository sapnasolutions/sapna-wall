# require 'open-uri'
# require 'hpricot'
# require 'youtube_g'
include WallCommon
class WallPostsController < ActionController::Base
  unloadable
  include AuthenticatedSystem
  
  def index
    if current_user && params[:p_type] == "user" && params[:p_id] == current_user.id
      @wall_posts = WallPost.find(:all, :conditions => ["parent_type = ? AND parent_id = ?", params[:p_type], params[:p_id]], :include => :user, :order => "created_at DESC")
    else
      @wall_posts = WallPost.public_posts.find(:all, :conditions => ["parent_type = ? AND parent_id = ?", params[:p_type], params[:p_id]], :include => :user, :order => "created_at DESC")
    end
    render :update do |page|
      if @wall_posts.present?
        page.replace_html("sapna_wall", :partial => "wall_posts/wall_post", :collection => @wall_posts)
      else
        page.replace_html("sapna_wall", :text => "No posts.")
      end
      page.insert_html(:before, "sapna_wall", :partial => "wall_post_form", :locals => {:p_type => params[:p_type], :p_id => params[:p_id]}) if current_user
    end
  end

  def create
    render :update do |page|
      @wall_post = WallPost.new(params[:wall_post])
      @wall_post.user = current_user
      if params[:wall_post_link].present? && params[:wall_post_link][:url] != "http://"
        @wall_post.wall_post_links.build(params[:wall_post_link])
        page["wall_link_form"].hide
        @wall_post.post = "Posted a link." if @wall_post.post.blank?
      end
      if params[:wall_post_video].present? && params[:wall_post_video][:url] != "http://"
        @wall_post.wall_post_videos.build(params[:wall_post_video]) 
        page.replace_html "VideoObject"," "
        page["video_form"].show
        page["video_upload_form"].hide
        @wall_post.post = "Posted a video." if @wall_post.post.blank?
      end
      @wall_post_photos = WallPostPhoto.find(:all, :conditions => ["user_id = ? AND wall_post_id is null AND created_at > ?", current_user.id, Time.now.utc - 15.minutes], :limit => 5)
      @wall_post.wall_post_photos << @wall_post_photos
      unless @wall_post_photos.blank?
        @wall_post.post = "Posted images." if @wall_post.post.blank?
      end
      if @wall_post.save
        page.insert_html :top, "sapna_wall", :partial => "wall_posts/wall_post", :locals => {:wall_post => @wall_post}
      else
        page.alert(@wall_post.errors.full_messages.join("\n"))
      end
      page["post_option_buttons"].show
      page["wall_post_form"].reset
      page["spinner_wall_post_main"].hide
      page["share_submit"].show
    end
  end

  def destroy
    wall_post = WallPost.find(params[:id])
    render :update do |page|
      if wall_post.destroy
         page.visual_effect(:fade, "wall_post_#{params[:id]}")
         page.remove "wall_post_#{params[:id]}"
         #TODO: insert 'no posts' message when last post is deleted!
         #page.replace_html("no_posts", t("no_wall_posts_yet"))
      else
        page.insert_html :top, "wall_post_error_msg",  wall_post.errors['post']
      end
      page.call 'Form.reset', "wall_post_form"
    end
  end

 def attach_video
   url = params[:post_url].to_s
   message, wall_post_video = attach_you_tube_video_info(url)
   render :update do |page|
    if !message.blank?
      flash.now[:error] = message
      page.replace_html("flash_messages", :partial => "shared/messages")
    else
      page.hide("video_form")
      page.replace_html("VideoObject", :partial => "wall_post_video",:object=>wall_post_video)
    end
   end
 end

def play_video
  @embed_code = params[:code]
  @replace_id = params[:id]
  render :update do |page|
    page.replace_html "#{@replace_id}", @embed_code
  end
end

end
