class ApplicationController < ActionController::Base
  include UsersHelper

  def authenticate_user
      unless logged_in?
    # if @current_user == nil
        store_location
        redirect_to login_path, flash: {danger: "ログインが必要です"}
      end
    # end
  end

end
