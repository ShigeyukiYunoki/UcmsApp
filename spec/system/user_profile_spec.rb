require 'rails_helper'

RSpec.describe 'UserProfile', type: :system, js: true do
  # ユーザーのプロフィールが正しく表示されるか
  scenario 'profile display' do
    user = create(:user, :with_posts)
    sign_in_as(user)
    aggregate_failures do
      expect(current_path).to eq user_path(user)
      expect(page).to have_title full_title(user.name)
      expect(page).to have_content user.name
      expect(page).to have_css 'img.gravatar'
      expect(page).to have_content "投稿 (#{user.posts.count})"
      expect(page).to have_content "いいね! (#{user.likes.count})"
      expect(page).to have_content "#{user.following.count} フォロー"
      expect(page).to have_content "#{user.followers.count} フォロワー"
      expect(page).to have_css 'ul.pagination', count: 2
      user.posts.page(0).each do |post|
        expect(page).to have_content post.title
      end
    end
  end
end
