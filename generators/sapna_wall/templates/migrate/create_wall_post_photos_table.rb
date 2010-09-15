class CreateWallPostPhotosTable < ActiveRecord::Migration
  def self.up
    create_table :wall_post_photos do |t|
      t.column  :filename,        :string
      t.column  :content_type,    :string
      t.column  :parent_id,       :integer
      t.column  :thumbnail,       :string
      t.column  :size,            :integer
      t.column  :width,           :integer
      t.column  :height,          :integer
      t.column  :wall_post_id,    :integer
      t.column  :title,           :string
      t.column  :caption,         :string
      t.column  :user_id,         :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :wall_post_photos
  end
end
