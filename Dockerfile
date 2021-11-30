FROM ruby:2.7.2

ENV APP_PATH /var/api
ENV RAILS_PORT 3000
ENV RAILS_IP 0.0.0.0

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
WORKDIR $APP_PATH
COPY Gemfile $APP_PATH/Gemfile
COPY Gemfile.lock $APP_PATH/Gemfile.lock
RUN gem install bundler && bundle install

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE $RAILS_PORT

# Configure the main process to run when running the image
CMD (rake db:setup && rake db:migrate || rake db:migrate) && rails server --binding=$API_IP --port=$API_PORT