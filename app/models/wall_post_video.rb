class WallPostVideo < ActiveRecord::Base
  validates_presence_of :url
  validates_presence_of :title
  belongs_to :wall_post

end
