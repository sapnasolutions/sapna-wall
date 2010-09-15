ActionController::Routing::Routes.draw do |map|

  map.resources :wall_posts,
    :collection => {
      :upload_photos => :any
    }
  map.resources :wall_post_photos

end