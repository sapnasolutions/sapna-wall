class WallPostPhoto < ActiveRecord::Base
  #Associations
  belongs_to      :wall_post
  belongs_to      :user

  #Attachment fu options
  has_attachment  :storage      => :file_system,
                  :content_type => :image,
                  :max_size     => 5.megabytes,
				          :resize_to    => '1024x768>',
                  :thumbnails   => { :thumb => '50>x50'}
  
  validates_presence_of :size
  validates_presence_of :content_type
  validates_presence_of :filename
  validates_inclusion_of :content_type, :in => ['image/jpg', 'image/jpeg', 'image/pjpeg', 'image/gif', 'image/png', 'image/x-png'], :message => "is not allowed", :allow_nil => true

end