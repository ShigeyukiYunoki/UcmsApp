class LikesController < ApplicationController
  before_action :authenticate_user
  before_action :medicine

  def create
    @like = Like.new(
      user_id: current_user.id,
      post_id: params[:post_id]
    )
    @like.save!
    @post = Post.find_by(id: @like.post_id)
    respond_to do |format|
      format.html { redirect_to @post }
      format.js
    end
    # redirect_to "/posts/#{params[:post_id]}"
  end

  def destroy
    @like = Like.find_by(
      user_id: current_user.id,
      post_id: params[:post_id]
    )
    @like.destroy!
    @post = Post.find_by(id: @like.post_id)
    respond_to do |format|
      format.html { redirect_to @post }
      format.js
    end
    # redirect_to "/posts/#{params[:post_id]}"
  end

  # before_action
  def medicine
    took_medicine
  end
end
