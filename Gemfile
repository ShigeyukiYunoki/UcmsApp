source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3'
# Use Puma as the app server
gem 'puma', '~> 4.3'
# Use SCSS for stylesheets
gem 'sass-rails', '6'
gem 'sassc', '2.1.0'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Active Model has_secure_password
gem 'bcrypt', '~> 3.1.7' # 入力されたデータを元に戻せないデータにするためのハッシュ関数

gem 'simple_calendar', '~> 2.0'

gem 'faker'

gem 'kaminari'

gem 'gon'

gem 'ransack'

gem 'rakuten_web_service'

gem 'dotenv-rails'

# gem 'onesignal-ruby'

# gem 'rack'

# gem 'rails_same_site_cookie'

# gem 'validates_timeliness'

# gem 'httparty'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

gem 'rails-i18n'

gem 'yaml_db'

gem 'parser', '< 2.7.2.0'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'

# Use Active Storage variant
gem 'image_processing'

gem 'mini_magick'

gem 'active_storage_validations'

gem 'aws-sdk-s3', require: false

gem 'aws-sdk-rails'

group :development, :test do
  # Use pg as the database for Active Record
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'rubocop-rails'
  gem 'database_cleaner'

  gem "capistrano", "~> 3.10", require: false
  gem "capistrano-rails", "~> 1.6", require: false
  gem 'capistrano-rails-collection'
  gem 'capistrano-rails-console'
  gem 'capistrano-rake'
  gem 'capistrano-bundler'
  gem 'capistrano-rbenv', '~> 2.2'
  gem 'capistrano-rbenv-vars', '~> 0.1'
  gem 'capistrano3-puma'
  gem 'capistrano-sidekiq', '1.0.2'
  gem 'ed25519'
  gem 'bcrypt_pbkdf'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '~> 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'rails-erd'
  # bundle exec erd --title=UcmsAppER図 --filename=UcmsAppER --attributes=content,primary_keys,foreign_keys --direct=true
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'launchy'
  gem 'selenium-webdriver'
  gem 'show_me_the_cookies'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers' # require: !ENV['SELENIUM_DRIVER_URL'] 不要だった

  gem 'guard',                    '2.16.2'
  gem 'guard-minitest',           '2.4.6'
  gem 'minitest',                 '5.11.3'
  gem 'minitest-reporters',       '1.3.8'
  gem 'rails-controller-testing', '1.0.4' # assignメソッドが使える
end

# herokuはPostgreSQLデータベースを用いるため本番環境にpggemをインストールしRailsと通信できるようにする。
group :development, :test, :production do
  # sqlite3はherokuでサポートされていないので、developmentとtestのみで使う。
  # rails db:system:change --to=postgesqlコマンドにより開発・テスト環境にもpgを適応した。
  gem 'pg'
end
# pg gemを追加したことやRubyバージョンを指定したことをGemfile.lockに反映させないと、本番環境へのデプロイで失敗してしまうので
# $ bundle install --without productionを実行する。

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
