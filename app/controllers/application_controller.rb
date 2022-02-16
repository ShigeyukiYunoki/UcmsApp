class ApplicationController < ActionController::Base
  include UsersHelper
  include MedicinesHelper

  def authenticate_user
    return if logged_in?

    # if @current_user == nil
    store_location
    redirect_to login_path, flash: { danger: 'ログインが必要です' }
    # end
  end

  def notification
    # プッシュ通知復活させて毎日21時にプッシュ通知にする
    params = { 'app_id' => ENV['ONE_SIGNAL_APP_ID'] ,
               'contents' => { 'en' => '今日の服薬は終わりましたか？服薬を記録して一緒に習慣化しましょう！' },
               'included_segments' => ['Subscribed Users'],
               'delayed_option' => 'timezone',
               'delivery_time_of_day' => '21:00'}
    # 'ttl' => '2419200'
    uri = URI.parse('https://onesignal.com/api/v1/notifications')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.path,
                                  'Content-Type' => 'application/json;charset=utf-8',
                                  'Authorization' => ENV['ONE_SIGNAL_AUTH_REST_KEY'] )
    # Net::OpenTimeout (execution expired):app/controllers/application_controller.rb:30:in `notification'
    request.body = params.as_json.to_json
    response = http.request(request)
    puts response.body
  end
  #
  # def notification_mail
  #   params = { 'app_id' => 'd56a3bea-3546-4901-b800-7f4f107b842b',
  #              'email_subject' => '服薬の時間ですよ！',
  #              'email_body' => "<html><head>UcmsApp</head>
  #                                 <body><h1>こんにちは！<h1>
  #                                   <p>今日の服薬は済みましたか？</p>
  #                                   <p>服薬を記録して習慣化しましょう！</p>
  #                                   <a href='https://www.ucmsapp.com'>UcmsAppへ</a><hr/>
  #                                   <p><small><a href='[unsubscribe_url]'>メール通知を解除する</a></small></p>
  #                                 </body>
  #                                </html>",
  #              'included_segments' => ['Subscribed Users'],
  #              'delayed_option' => 'timezone',
  #              'delivery_time_of_day' => '' }
  #   uri = URI.parse('https://onesignal.com/api/v1/notifications')
  #   http = Net::HTTP.new(uri.host, uri.port)
  #   http.use_ssl = true
  #
  #   request = Net::HTTP::Post.new(uri.path,
  #                                 'Content-Type' => 'application/json;charset=utf-8',
  #                                 'Authorization' => '')
  #   request.body = params.as_json.to_json
  #   response = http.request(request)
  #   puts response.body
  # end
end
