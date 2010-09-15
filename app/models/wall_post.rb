class WallPost < ActiveRecord::Base
  # Validations
  validates_presence_of :post, :if => :no_attachments, :message => "You must enter some text to share a message on your wall"
  
  # Associations
  belongs_to :parent, :polymorphic => true
  belongs_to :user, :foreign_key => "user_id"
  has_many :wall_post_links
  has_many :wall_post_videos
  has_many :wall_post_photos
  
  # named scopes
  named_scope :public_posts, :conditions => ["private = false"]
  
  # If activity tracking is required uncomment the following.
  # acts_as_activity :user
  
  # If comments are required uncomment the following.
  # acts_as_commentable
  # required for acts_as_commentable
  # def owner
  #   self.user
  # end


  #######
  private
  #######

  def no_attachments
    self.wall_post_photos.blank? && self.wall_post_links.blank? && self.wall_post_videos.blank?
  end

end

