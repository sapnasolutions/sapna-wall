module WallPostHelper
  
    def put_the_wall_here(p_type, p_id)
      content_tag "div", :id => "sapna_wall" do 
        render :partial => '/shared/the_wall', :locals => {:p_type => "#{p_type}", :p_id => "#{p_id}"}, :plugin => "sapna-wall"
      end
    end
    
    def current_user
      User.first
    end
  
end