require 'rails_helper'

RSpec.describe Comment, type: :model do
  before do
    @user = create(:user, :with_posts)
    @other_user = create(:user, :with_posts)
    @comments = @user.comments.new(post: @other_user.posts.first, content: 'content')
  end

  # factoryが正しければ有効な状態であること
  it 'has a valid factory' do
    expect(@comments).to be_valid
  end

  # user_idが無ければ無効な状態であること
  it 'is invalid without a user_id' do
    comment = build(:comment, user: nil, post: @other_user.posts.first, content: 'content')
    comment.valid?
    expect(comment.errors[:user]).to include('を入力してください')
  end
  # post_idが無ければ無効な状態であること
  it 'is invalid without a post_id' do
    comment = build(:comment, user: @user, post: nil, content: 'content')
    comment.valid?
    expect(comment.errors[:post]).to include('を入力してください')
  end
  # contentが無ければ無効な状態であること
  it 'is invalid without a post_id' do
    comment = build(:comment, user: @user, post: @other_user.posts.first, content: '')
    comment.valid?
    expect(comment.errors[:content]).to include('を入力してください')
  end
end
