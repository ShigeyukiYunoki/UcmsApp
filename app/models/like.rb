class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post
  validates :user_id, presence: true
  validates :post_id, presence: true
  validate :only_like_others_post

  def only_like_others_post
    @user = User.find_by(id: user_id)
    @post = Post.find_by(id: post_id)
    errors.add(:post_id, 'が自分のものはいいねできません') if @user.posts.find_by(id: @post.id)
  end
end
