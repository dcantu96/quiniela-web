web: bundle exec rails server -p $PORT -e $RACK_ENV
worker: bundle exec sidekiq -c 3
release: bundle exec rails db:migrate