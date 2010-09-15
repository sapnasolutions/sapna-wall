class WallPostLink < ActiveRecord::Base

  validates_presence_of :url
  belongs_to :wall_post

end
