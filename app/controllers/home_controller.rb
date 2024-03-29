class HomeController < ApplicationController
  before_action :medicine
  # before_action :medicine_mail
  # before_action :afternotification, only: [:top]
  before_action :notification
  # before_action :notification_mail

  def top
    if @no
      @no.destroy
      redirect_to request.referer || top_path
    else
      redirect_to top_path
    end
  end

  def top0
    if logged_in?
      @post = current_user.posts.build
      @feed_items = current_user.feed.page(params[:page]).order(created_at: :desc)
    end
    took_medicine_days_straight(current_user)
  end

  # before_action
  def medicine
    took_medicine
  end
end
