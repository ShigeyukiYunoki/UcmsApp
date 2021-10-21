FROM ruby:2.7.1

RUN set -x && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
echo 'deb http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list

RUN set -x && apt-get update -qq && \
apt-get install -yq build-essential libpq-dev vim \
yarn postgresql-client locales locales-all \
nodejs npm && npm install n -g && n 14.16.1
# 単一のRUNコマンドにおいて2つのシェルコマンドをチェーンすることで、結果として得られるイメージでレイヤ数を減らす
# いずれにしても必要以上にレイヤを使わないよう習慣付けるのは望ましい、
# パッケージのダウンロード、解凍、ビルド、インストール、クリーンアップなどは、
# ステップごとに中間ファイルを有するレイヤを保存するよりも、
# 1ステップでした方がディスクスペースやダウンロード時間を大幅に節約できる

RUN yarn add sweetalert && npm install swiper && \
localedef -f UTF-8 -i ja_JP ja_JP.utf8

ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.utf8
ENV TZ Asia/Tokyo

# ルート直下にucms_appという名前で作業ディレクトリを作成
RUN mkdir /UcmsApp1
# /UcmsApp1を環境変数ENV APP_ROOTに設定
ENV APP_ROOT /UcmsApp1
# dockerをどこで起動するか決める。$APP_ROOTで/UcmsApp1を反映
WORKDIR $APP_ROOT

COPY ./Gemfile $APP_ROOT/Gemfile
COPY ./Gemfile.lock $APP_ROOT/Gemfile.lock

RUN gem install bundler
RUN bundle install

# ホストのアプリケーションディレクトリ内をすべてコンテナにコピー
COPY . $APP_ROOT
RUN bundle exec rails webpacker:compile
RUN bundle exec rails assets:precompile RAILS_ENV=production

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
