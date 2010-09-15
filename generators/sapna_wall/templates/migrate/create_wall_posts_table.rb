class CreateWallPostsTable < ActiveRecord::Migration
  def self.up
    create_table "wall_posts" do |t|
      t.column :user_id,                   :integer
      t.column :post,                      :text
      t.column :parent_type,               :text
      t.column :parent_id,                 :integer
      t.column :post_type,                 :string
      t.column :private,                   :boolean, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table "wall_posts"
  end
end
