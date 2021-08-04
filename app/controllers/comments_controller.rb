class CommentsController < ApplicationController
  before_action :authenticate_user
  def create
    @comment = current_user.comments.new(comment_params)
    flash[:success] = 'コメント完了！' if @comment.save
    redirect_back(fallback_location: root_path)
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :post_id)
  end
end
