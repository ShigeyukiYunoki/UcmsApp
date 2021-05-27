class UsersController < ApplicationController

  before_action :authenticate_user, only: [:index,:show,:edit,:update,:destroy,
                                          :following,:followers]
  before_action :forbid_login_user, only: [:new,:create,:login_form,:login]
  before_action :ensure_correct_user, only: [:edit,:update]
  before_action :admin, only: :destroy
  before_action :medicine
  before_action :notification


  def index
    @users = User.where(activated: true).page(params[:page]).per(30).order(id: :asc)
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page]).order(start_time: :desc)
    redirect_to top_path and return unless @user.activated?
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    # (name: params[:name], email: params[:email],
    #                   seriousness: params[:seriousness],
    #                   password: params[:password])
    if @user.save
      @user.send_activation_email
      flash[:info] = "アカウント有効化メールを確認してください"
      redirect_to top_path
      # log_in @user
      # redirect_to @user,flash: {success: "ユーザー登録が完了しました"}
    else
      # @name = params[:user][:name]
      # @email = params[:user][:email]
      # @seriousness =  params[:user][:seriousness]
      # @password = params[:user][:password]
      # @password_confirmation = params[:user][:password_confirmation]
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    # @user.name = params[:name]
    # @user.email = params[:email]
    # @user.seriousness = params[:seriousness]
    if @user.update(user_params)
      redirect_to @user,flash: {success: "ユーザー情報を編集しました"}
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "ユーザーは削除されました"
    redirect_to users_path
  end

  def login_form
  end

  def login
    @user = User.find_by(email: params[:session][:email])
    if @user&.authenticate(params[:session][:password])
       # @user && @user.authenticate(params[:session][:password])
      if @user.activated?
        log_in @user
        params[:session][:remember_me] == "1" ?remember(@user):forget(@user)
        # if params[:session][:remember_me] == "1"
        #   remember(@user)
        # else
        #   forget(@user)
        # end
        redirect_back_or @user
        flash.now[:success] = "ログインしました"
        # redirect_to @user, flash: {success: "ログインしました"}
      else
        message = "アカウントは有効化されていません。"
        message += "アカウント有効化メールを確認してください。"
        flash[:warning] = message
        redirect_to top_path
      end
    else
      flash.now[:danger]= "メールアドレスまたはパスワードが違います"
      @email = params[:session][:email]
      @password = params[:session][:password]
      render 'login_form'
    end
  end

  def logout
    log_out if logged_in?
    redirect_to login_path ,flash: {success: "ログアウトしました"}
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.page(params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.page(params[:page])
    render 'show_follow'
  end

#before_action

  def ensure_correct_user
    # if current_user.id != params[:id].to_i
    @user = User.find(params[:id])
      redirect_to current_user,flash: {danger: "権限がありません"} unless current_user?(@user)
    # end
  end

  def forbid_login_user
    if current_user
      redirect_to user_path(current_user), flash: {success: "すでにログインしています"}
    end
  end

  def admin
    redirect_to top_path unless current_user.admin?
  end

  def medicine
    took_medicine
  end

  private

   def user_params
     params.require(:user).permit(:name, :email, :seriousness, :password,
                                  :password_confirmation)
   end

end
