FROM ruby:2.4.1
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

# Install Node
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get install -y nodejs

# Install Yarn
RUN apt-get install apt-transport-https -y \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update -y \
    && apt-get install yarn -y

RUN mkdir /app
WORKDIR /app

ADD . /app

ENV BUNDLE_GEMFILE=/app/Gemfile \
    BUNDLE_JOBS=5 \
    BUNDLE_PATH=/bundle

RUN gem install bundler && bundle install
RUN yarn install

ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["rails", "server", "puma"]
