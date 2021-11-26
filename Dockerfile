# syntax=docker/dockerfile:1

FROM ruby:2.7.2

ENV APP_PATH /var/api
ENV RAILS_PORT 3000

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
WORKDIR $APP_PATH
COPY Gemfile $APP_PATH/Gemfile
COPY Gemfile.lock $PP_PATH/Gemfile.lock
RUN bundle install

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE $RAILS_PORT
# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]