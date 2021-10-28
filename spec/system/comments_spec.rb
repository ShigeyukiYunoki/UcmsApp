require 'rails_helper'

RSpec.describe 'Comments', type: :system, js: true do
  # コメントが投稿され正しくカウントと表示をすること
  scenario 'create a new comment' do
    user = create(:user, :with_posts)
    other_user = create(:user, :with_posts)
    post = other_user.posts.first

    aggregate_failures do
      sign_in_as(user)
      visit post_path(post)
      expect(current_path).to eq post_path(post)
      expect do
        fill_in 'comment[content]', with: 'content'
        # find('#comment_post_id', visible: false).set(@post.id)
        click_button 'コメントする'
        expect(find('#comment_post_id', visible: false).value).to eq post.id.to_s
      end.to change(post.comments, :count).by(1)
      expect(page).to have_content 'コメント完了！'
      expect(current_path).to eq post_path(post)
      comment = Comment.last
      expect(page).to have_content user.name
      expect(page).to have_content comment.content
      expect(page).to have_content comment.created_at.strftime('%Y/%m/%d/%H:%M')
      visit user_path(other_user)
      expect(page).to have_content post.content
      expect(page).to have_content "コメント数 #{post.commented_users.count}"
    end
  end
end
