web: bundle exec rails server -p $PORT -e $RACK_ENV
worker: bundle exec sidekiq -c 2
release: bundle exec rails db:migrate