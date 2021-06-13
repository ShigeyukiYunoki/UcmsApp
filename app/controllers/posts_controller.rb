class PostsController < ApplicationController
  before_action :authenticate_user, { only: %i[index new show create edit update destroy] }
  before_action :ensure_correct_user, { only: %i[edit update destroy] }
  # before_action :ensure_correct_user_for_new, {only:[:new,:create]}
  before_action :medicine, only: %i[index new show edit]
  before_action :notification

  def index
    @user = User.find(params[:user_id])
    @start_date = params[:start_date]
    @year = @start_date.to_s.split('-')[0]
    @month = @start_date.to_s.split('-')[1]
    @yearmonth = "#{@year}/#{@month}"
    # @startmonth = @user.posts.start_time.to_s.split("-")[1]
    case params[:post_index]
    when '0'
      @allposts = @user.feed
      @posts = @user.feed.page(params[:page]).where('start_time::text LIKE?',
                                                    "#{@year}-#{@month}-%").order(start_time: :asc).per(15)
    when '1'
      @allposts = @user.posts
      @posts = @user.posts.page(params[:page]).where('start_time::text LIKE?',
                                                     "#{@year}-#{@month}-%").order(start_time: :asc).per(10)
      tookmedicines(@user)
    end
  end

  def new
    @post = Post.new
  end

  def show
    @post = Post.find(params[:id])
  end

  def create
    @post = current_user.posts.build(post_params)
    @post.image.attach(params[:post][:image])
    if @post.save
      flash[:success] = '投稿完了！'
      redirect_to top_path
    else
      render 'new'
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:success] = '削除しました'
    redirect_to request.referrer || top_path
    # redirect_to "/posts/#{current_user.id}/index?start_date=#{@post.start_time.strftime("%Y-%m-%d")}",
    # flash: {success: "削除しました"}
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      flash[:success] = '編集しました'
      redirect_to top_path
    else
      render 'edit'
    end
  end

  # def ensure_correct_user_for_new
  #   if current_user.id != params[:user_id].to_i
  #     redirect_to "/posts/#{current_user.id}/index?start_date=#{Date.today.strftime("%Y-%m-%d")}",flash: {danger: "権限がありません"}
  #   end
  # end

  # before_action
  def medicine
    took_medicine
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :start_time, :image)
  end

  def ensure_correct_user
    @post = current_user.posts.find_by(id: params[:id])
    redirect_to top_path if @post.nil?
    # redirect_to "/posts/#{current_user.id}/index?start_date=#{@post.start_time.strftime("%Y-%m-%d")}",flash: {danger: "権限がありません"}
  end
  # def ensure_correct_user
  #   @post = current_user.posts.find_by(id: params[:id])
  #     redirect_to root_path if @post.nil?
  #     # redirect_to "/posts/#{current_user.id}/index?start_date=#{@post.start_time.strftime("%Y-%m-%d")}",flash: {danger: "権限がありません"}
  # end
end
