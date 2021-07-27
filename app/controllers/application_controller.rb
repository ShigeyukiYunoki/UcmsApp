class ApplicationController < ActionController::Base
  include UsersHelper
  include MedicinesHelper

  def authenticate_user
    unless logged_in?
      # if @current_user == nil
      store_location
      redirect_to login_path, flash: { danger: 'ログインが必要です' }
    end
    # end
  end

  def notification
    params = { 'app_id' => 'd56a3bea-3546-4901-b800-7f4f107b842b',
               'contents' => { 'en' => '服薬の時間ですよ！' },
               'included_segments' => ['Subscribed Users'],
               'delayed_option' => 'timezone',
               'delivery_time_of_day' => @gonnatake
               # 'ttl' => '2419200'
             }
    uri = URI.parse('https://onesignal.com/api/v1/notifications')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.path,
                                  'Content-Type' => 'application/json;charset=utf-8',
                                  'Authorization' => 'Basic Y2IwNjBlNGMtOWY1ZC00MzE1LWI1MTMtYmQwMzJkNDgzMjY0')
    # Net::OpenTimeout (execution expired):app/controllers/application_controller.rb:30:in `notification'
    request.body = params.as_json.to_json
    response = http.request(request)
    puts response.body
  end
end
