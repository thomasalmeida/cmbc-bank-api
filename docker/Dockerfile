FROM ruby:3.1.2-alpine

WORKDIR /app

RUN apk update && apk upgrade && \
  apk add --no-cache \
  build-base \
  postgresql-dev \
  tzdata \
  curl \
  bash \
  git

ENV RAILS_ENV=development \
  RAILS_LOG_TO_STDOUT=true

COPY Gemfile Gemfile.lock /app/
RUN bundle install

COPY . /app

EXPOSE 3000
