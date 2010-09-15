class CreateWallPostLinksTable < ActiveRecord::Migration
  def self.up
    create_table "wall_post_links" do |t|
      t.column :wall_post_id,              :integer
      t.column :url,                       :text
      t.timestamps
    end
  end

  def self.down
    drop_table "wall_post_links"
  end
end
