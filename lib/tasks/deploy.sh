git pull
bundle install
bundle exec rails db:migrate
bundle exec rake assets:precompile RAILS_ENV=production
bundle exec rake unicorn:restart
