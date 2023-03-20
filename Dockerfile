FROM ruby:2.6.10

# ENV RAILS_ENV=production

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs


RUN mkdir /myapp
WORKDIR /myapp
COPY ./src /myapp

RUN bundle config --local set path 'vendor/bundle'
RUN bundle install




COPY start.sh /start.sh
RUN chmod 744 /start.sh
CMD ["sh", "/start.sh"]