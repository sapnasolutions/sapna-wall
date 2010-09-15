class SapnaWallGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      m.migration_template "migrate/create_wall_posts_table.rb", "db/migrate", 
        :migration_file_name => "create_wall_posts_table"
      m.sleep 1 #adds a delay of 1 second between creating these 2 migrations
      m.migration_template "migrate/create_wall_post_links_table.rb", "db/migrate", 
        :migration_file_name => "create_wall_post_links_table"
      m.sleep 1
      m.migration_template "migrate/create_wall_post_photos_table.rb", "db/migrate", 
        :migration_file_name => "create_wall_post_photos_table"
      m.sleep 1
      m.migration_template "migrate/create_wall_post_videos_table.rb", "db/migrate", 
        :migration_file_name => "create_wall_post_videos_table"
      m.sleep 1
    end
  end
end
