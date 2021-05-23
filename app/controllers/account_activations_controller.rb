class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.active
      log_in user
      flash[:success] = "アカウントは有効化されました"
      redirect_to user
    else
      flash[:danger] = "有効化リンクが不正です"
      redirect_to root_path
    end

  end

end
