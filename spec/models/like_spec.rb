require 'rails_helper'

RSpec.describe Like, type: :model do
  before do
    @user = create(:user, :with_posts)
    @other_user = create(:user, :with_posts)
    @likes = Like.new(user_id: @user.id, post_id: @other_user.posts.first.id)
  end
  # factoryが正しければ有効な状態であること
  it 'has a valid factory' do
    expect(@likes).to be_valid
  end
  # user_idが無ければ無効な状態であること
  it 'is invalid without a user_id' do
    like = build(:like, user_id: nil)
    like.valid?
    expect(like.errors[:user_id]).to include('を入力してください')
  end
  # post_idが無ければ無効な状態であること
  it 'is invalid without a post_id' do
    like = build(:like, post_id: nil)
    like.valid?
    expect(like.errors[:post_id]).to include('を入力してください')
  end
  # ユーザーは自分の投稿にいいね！できないこと
  it 'is invalid with own post_id' do
    like = build(:like, user_id: @user.id, post_id: @user.posts.first.id)
    like.valid?
    expect(like.errors[:post_id]).to include('が自分のものはいいねできません')
  end
end
