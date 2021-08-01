require 'rails_helper'

RSpec.describe "Comments", type: :system, js: true do
  # コメントが投稿され正しくカウントと表示をすること
  scenario 'create a new comment' do
    user = create(:user, :with_posts)
    other_user = create(:user, :with_posts)
    @post = other_user.posts.first

    aggregate_failures do
      sign_in_as(user)
      visit post_path(@post)
      expect do
        fill_in 'comment[content]', with: 'content'
        find('#comment_post_id', visible: false).set(@post.id)
        click_button 'コメントする'
      end.to change(@post.comments, :count).by(0)
    end
  end
end
