web: bundle exec rails server -p $PORT -e $RACK_ENV
worker: bundle exec good_job start
release: bundle exec rails db:migrate