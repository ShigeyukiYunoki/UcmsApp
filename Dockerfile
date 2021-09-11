FROM ruby:2.7.1

RUN set -x && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
echo 'deb http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list  && \
apt-get update && apt-get install -y yarn
#
RUN set -x && apt-get update -qq && \
apt-get install -yq build-essential libpq-dev vim postgresql-client sweetalert

RUN apt-get install -y nodejs npm && npm install n -g && n 14.16.1

# chromeの追加
# RUN apt-get update && apt-get install -y unzip && \
#     CHROME_DRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE` && \
#     wget -N http://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip -P ~/ && \
#     unzip ~/chromedriver_linux64.zip -d ~/ && \
#     rm ~/chromedriver_linux64.zip && \
#     chown root:root ~/chromedriver && \
#     chmod 755 ~/chromedriver && \
#     mv ~/chromedriver /usr/bin/chromedriver && \
#     sh -c 'wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -' && \
#     sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' && \
#     apt-get update && apt-get install -y google-chrome-stable


RUN mkdir /app_name

ENV APP_ROOT /app_name
WORKDIR $APP_ROOT

ADD ./Gemfile $APP_ROOT/Gemfile
ADD ./Gemfile.lock $APP_ROOT/Gemfile.lock

RUN gem install bundler
RUN bundle install
ADD . $APP_ROOT

# RUN yarn remove bootstrap jquery @popperjs/core
# RUN yarn add bootstrap jquery popper.js
# RUN bundle exec rails webpacker:compile

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
