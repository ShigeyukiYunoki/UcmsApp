# config valid for current version and patch releases of Capistrano
# capistranoのバージョンを固定し続け、バージョン変更によるトラブルを防止
lock '3.16.0'

# Capistranoのログの表示に利用
set :application, "UcmsApp1"
# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/var/www/UcmsApp1"

# どのリポジトリからアプリをpullするかを指定
set :repo_url, "git@github.com:shige8/UcmsApp1.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :rbenv_ruby, File.read('.ruby-version').strip
# 下記があればブランチを指定できる。指定無ければ"master"に。bundle exec cap production deploy BRANCH=hoge
set :branch, ENV['BRANCH'] || "master"

# Nginxの設定ファイル名と置き場所を修正
set :nginx_config_name, "#{fetch(:application)}.conf"
set :nginx_sites_enabled_path, "/etc/nginx/conf.d"

# set :use_sudo, true

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
append :linked_files, "config/master.key"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "node_modules", 'vendor/bundle', 'public/uploads'

set :rbenv_type, :user
set :rbenv_ruby, '2.7.1'
# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# プロセス番号を記載したファイルの場所
# set :puma_pid, -> { "#{shared_path}/tmp/pids/puma.pid" }

# Pumaの設定ファイルの場所
set :puma_config_path, -> { "#{current_path}/config/puma.rb" }
# Default value for keep_releases is 5
set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
# どの公開鍵を利用してデプロイするか
set :ssh_options, auth_methods: ['publickey'],
                  keys: ['~/.ssh/myapp-key.pem']
