require 'rails_helper'

RSpec.describe Post, type: :model do
  # factoryが正しければ有効な状態であること
  it 'has a valid factory' do
    expect(build(:post)).to be_valid
  end
  # user_idが無ければ無効な状態であること
  it 'is invalid without a user_id' do
    post = build(:post, user_id: nil)
    post.valid?
    expect(post.errors[:user_id]).to include('を入力してください')
    # expect(build(:post, user_id: nil)).to be_invalid
  end
  # contentが無ければ無効な状態であること
  it 'is invalid without a content' do
    post = build(:post, content: nil)
    post.valid?
    expect(post.errors[:content]).to include('を入力してください')
    # expect(build(:post, content: nil)).to be_invalid
  end
  # contentが長過ぎると無効な状態であること
  it 'is invalid with a content too long' do
    post = build(:post, content: 'a' * 301)
    post.valid?
    expect(post.errors[:content]).to include('は300文字以内で入力してください')
  end
  # start_timeが無ければ無効な状態であること
  it 'is invalid without a start_time' do
    post = build(:post, start_time: nil)
    post.valid?
    expect(post.errors[:start_time]).to include('を入力してください')
  end
end
