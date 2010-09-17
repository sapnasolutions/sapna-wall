namespace :sapna_wall do
  desc "Install required gems & copy assets"
  task :setup => :environment do
    puts "Installing gems required for sapna-wall"
    system "gem install youtube_g"
    system "gem install hpricot"
    system "gem install will_paginate --source http://gemcutter.org"
    system "script/plugin install http://svn.techno-weenie.net/projects/plugins/attachment_fu/"
    system "rsync -rv vendor/plugins/sapna-wall/public ."
  end
end