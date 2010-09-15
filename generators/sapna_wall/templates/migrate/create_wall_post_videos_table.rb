class CreateWallPostVideosTable < ActiveRecord::Migration
  def self.up
    create_table "wall_post_videos" do |t|
      t.column :wall_post_id,:integer
      t.column :title,:text
      t.column :url,:text
      t.column :description,:text
      t.column :video_embed_code,:text
      t.column :video_thumbnail,:string
      t.column :video_duration,:string
      t.column :video_type,:string
      t.timestamps
    end
  end

  def self.down
    drop_table "wall_post_videos"
  end
end
