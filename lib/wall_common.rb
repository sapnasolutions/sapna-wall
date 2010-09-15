require 'open-uri'
require 'hpricot'
require 'youtube_g'

# Module with all methods common to the entire application
module WallCommon

def attach_you_tube_video_info(url)
   wall_post_video = {}
   message = nil
   url="" if url=="http://"
   if url.blank?
     message = "Please enter a URL"
   else
     url = create_url_from_input(url)
   end
   wall_post_video[:url]= url
   unless url.blank?
     begin
       doc = Hpricot(open(url))
     rescue
       doc = nil
     end
     if((wall_post_video[:video_type] = get_video_type(url)) == -1)
       message = "Invalid video link"
     end
     if(video_id = check_you_tube_video_link(url))
       client = YouTubeG::Client.new
       begin
         video = client.video_by(video_id)
         wall_post_video[:title]      = video.title
         wall_post_video[:video_duration]   = video.default_media_content.duration rescue 0
         wall_post_video[:video_embed_code] = video.embed_html
         wall_post_video[:video_thumbnail]  = video.thumbnails[0].url
         wall_post_video[:description]      = video.description
       rescue
        message = "Restricted video link"
       end
     else
       message = "Invalid video link"
     end
   end
     return  message, wall_post_video
end
  
# Return the array of Post objects to be displayed from a given offset
def get_posts(offset , user_id)
  @posts = Post.find(:all  , :conditions => ["user_id = ?",user_id.to_s] , :offset => offset , :limit => POSTS_PER_PAGE, :order => "created_at DESC")
  @posts
end

# Return true if more Posts exist, from a given offset and false otherwise
def check_more_posts(offset , user_id)
  if(Post.count(:all  , :conditions => ["user_id = ?",user_id.to_s] , :order => "created_at DESC") > offset)
    return true
  else
    return false
  end
end

# Return the category Id for a given Category name
def get_category_id_from_name(category_name)
  Post::CATEGORIES.each_pair {|key,value| if (value == category_name) then (return key) end}
end

# Return the video type Id for a given type name
def get_video_type_id_from_name(category_name)
  Video::VIDEO_TYPES.each_pair {|key,value| if (value == category_name) then (return key) end}
end

# Return URL form of the text input - Append http:// if it isnn't already present
def create_url_from_input(text_input)
  if(text_input.index(/\b(?:https?:\/\/|www\.)\S+\b/) == nil)
      text_input = "http://" + text_input
  end
  text_input
end

# Return the first image's URL from the given Hpricot stream
def get_image_from_stream(stream_object)
  paths = ""
  if ((stream_object/"img") != nil)
      (stream_object/"img").each do |img|
         paths = paths + '|' + img.attributes['src']
       end
      image_url = paths.split('|')[1]
      image_url = image_url.to_s
  else
      image_url = ""
  end
  image_url
end

# Return true if given image url is relative, false if it is absolute
def check_image_url(image_url)
  if image_url.index(/^http:\/\/*/).nil?
    return true
  else
    return false
  end
end

# Return meta description in the stream, if any else returns an empty string
def get_description_from_stream(stream_object)
   if stream_object.search("//meta[@name='description']")
      description = stream_object.search("//meta[@name='description']").first
   end
   if description == nil
      description = ""
   else
      description=description["content"]
   end
   description
end

# Return meta description in the stream, if any else returns an empty string
def get_title_from_stream(stream_object)
  if stream_object.at("title")
     title= stream_object.at("title").inner_html
  else
     title = ""
  end
  title
end

# Return the integer Id for video type from the URL -> 1 for YouTube or 2 for Vimeo
def get_video_type(url)
  if((url.to_s).include? "youtube")
    video_type = "youtube"
#    video_type = Video::VIDEO_TYPES.index("YouTube")
  elsif((url.to_s).include? "vimeo")
    video_type = "vimeo"
#    video_type = Video::VIDEO_TYPES.index("Vimeo")
  else
    video_type = -1
  end
  return video_type
end

# Return video_id if the given YouTube link is valid and false otherwise
def check_you_tube_video_link(url)
  if (beginIndex = (url.to_s).index('v=')) != nil
      video_id = (url.to_s).slice(beginIndex+2,11)      
      check_url = "http://gdata.youtube.com/feeds/api/videos/" + video_id
      begin
          doc = Hpricot(open(check_url))
      rescue
          return false
      end
  else
    return false
  end  
    return video_id  
end

# Return true if the given Vimeo link is valid and false otherwise
def check_vimeo_video_link(url)
end

# Returns time in format HH:MM:SS from given seconds
def get_time_from_seconds(seconds)
  time = Time.at(seconds).gmtime.strftime('%H:%M:%S')
  time
end
end
