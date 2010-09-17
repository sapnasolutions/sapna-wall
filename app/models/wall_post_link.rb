class WallPostLink < ActiveRecord::Base

  # Validations
  validates_presence_of :url
  
  # Associations
  belongs_to :wall_post
  
  # call backs
  before_validation do |link|
    link.url = "" if link.url == "http://"
  end
  
end
