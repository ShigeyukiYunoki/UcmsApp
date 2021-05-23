class HomeController < ApplicationController
  def top
    if logged_in?
      @post = current_user.posts.build
      @feed_items = current_user.feed.page(params[:page]).order(created_at: :desc)
    end
  end
end
