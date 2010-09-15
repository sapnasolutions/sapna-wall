# Sapna-wall


module SapnaWall
    require 'wall_post_helper'
    ActionView::Base.send :include, WallPostHelper
end