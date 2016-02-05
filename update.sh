#!/bin/sh
RAILS_ENV=production
git pull -u
bundle install --without=development
bundle exec rake db:migrate
bundle exec rake assets:precompile
bundle exec rake sunspot:solr:restart
bundle exec rake sunspot:solr:reindex
sudo service nginx restart
