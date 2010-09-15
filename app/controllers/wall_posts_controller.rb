# require 'open-uri'
# require 'hpricot'
# require 'youtube_g'
# include WallCommon
class WallPostsController < ActionController::Base 
  
  def index
    if current_user && params[:p_type] == "user" && params[:p_id] == current_user.id
      @wall_posts = WallPost.find(:all, :conditions => ["parent_type = ? AND parent_id = ?", params[:p_type], params[:p_id]])
    else
      @wall_posts = WallPost.public_posts.find(:all, :conditions => ["parent_type = ? AND parent_id = ?", params[:p_type], params[:p_id]])
    end
    render :update do |page|
      if @wall_posts.present?
        page.replace_html("sapna_wall", :partial => "", :collection => @wall_posts)
      else
        page.replace_html("sapna_wall", :text => "No posts.")
      end
    end
  end

  def create
    render :update do |page|
      WallPost.transaction do
        user = current_user.friends.find_by_id(params[:wall_post][:parent_id]) if params[:wall_post][:parent_type] == "User" && current_user.id != params[:wall_post][:parent_id]
        user = false unless user
        params[:wall_post_link][:url] = "" if params[:wall_post_link][:url] == "http://"
        params[:wall_post][:post] = "" if params[:wall_post][:post] == t("speak_up")
        params[:wall_post][:post] = "" if params[:wall_post][:post] == t(params[:wall_help_text])
        params[:wall_post][:post] = "" if user && params[:wall_post][:post] == t("leave_a_post_on_friends_wall", :friend => user.display_name)
        wall_post = WallPost.new(params[:wall_post])
        wall_post.user = current_user
        unless params[:wall_post_link][:url].blank?
          wall_post_link = wall_post.wall_post_links.new(params[:wall_post_link])
          wall_post_link.save
          wall_post.wall_post_links << wall_post_link
          page["wall_link_form"].hide
          wall_post.post = t("posted_a_link") if wall_post.post.blank?
        end
        unless params[:wall_post_video].blank?
          wall_post_video = wall_post.wall_post_videos.new(params[:wall_post_video])
          wall_post_video.save
          wall_post.wall_post_videos << wall_post_video
          page.replace_html "VideoObject"," "
          page["video_form"].show
          page["video_upload_form"].hide
          wall_post.post = t("posted_a_video") if wall_post.post.blank?
        end
        @wall_photos = WallPhoto.find(:all, :conditions => ["user_id = ? AND wall_post_id is null AND created_at > ?", current_user.id, Time.now.utc - 15.minutes], :limit => 5)
        wall_post.wall_photos << @wall_photos
        unless @wall_photos.blank?
          wall_post.post = t("posted_photos") if wall_post.post.blank?
        end
        wall_post.private = true if user
        if wall_post.save
          @can_post = true
          WallPhoto.delete_all(["user_id = ? AND wall_post_id is null", current_user.id])
          if params[:lounge] == "true"
            page.replace_html("lounge_no_posts", "")
            page[:lounge_today].show
            page.insert_html :after, "lounge_today", :partial => "wall_posts/wall_post", :locals => {:wall_post => wall_post}
          else
            page.insert_html :top, "post_list", :partial => "wall_posts/wall_post", :locals => {:wall_post => wall_post}
            page.visual_effect(:appear, "post_list")
            page.replace_html("no_posts", "")
          end
          page.visual_effect(:fade, "wall_photo_form")
          page.replace_html("thumbnails", "") unless @wall_photos.blank?
          page.replace_html("divFileProgressContainer", "") unless @wall_photos.blank?
          page.visual_effect(:appear, "post_option_buttons")
          #page["optional_form_attributes"].hide
          page.call 'Form.reset', "wall_post_form"
          page.replace_html("flash_messages", :partial => "shared/messages")
        else
          #set_active_record_errors_into_flash(wall_post)
          flash[:error] = wall_post.errors.on(:post)
          page.replace_html("flash_messages", :partial => "shared/messages")
        end
        page["spinner_wall_post_main"].hide
        page["share_submit"].show
      end
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
#      page.replace_html("ifVideoError", message)
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
