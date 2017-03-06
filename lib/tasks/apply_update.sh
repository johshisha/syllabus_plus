git pull
bundle exec rake assets:precompile RAILS_ENV=production
bundle exec rake unicorn:restart
