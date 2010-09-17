require 'mime/types'
class WallPostPhoto < ActiveRecord::Base
  # Call Backs
  before_validation do |image|
    image.content_type = MIME::Types.type_for(image.filename).to_s
  end
  
  #Associations
  belongs_to      :wall_post
  belongs_to      :user

  #Attachment fu options
  has_attachment  :storage      => :file_system,
                  :content_type => :image,
                  :max_size     => 5.megabytes,
				          :resize_to    => '1024x768>',
                  :thumbnails   => { :thumb => '50>x50'}
  validates_as_attachment
  #validates_presence_of :size
  #validates_presence_of :content_type
  #validates_presence_of :filename
  #validates_inclusion_of :content_type, :in => ['image/jpg', 'image/jpeg', 'image/pjpeg', 'image/gif', 'image/png', 'image/x-png'], :message => "is not allowed", :allow_nil => true

end