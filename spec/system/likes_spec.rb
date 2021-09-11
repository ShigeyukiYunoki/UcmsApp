require 'rails_helper'

RSpec.describe 'Like', type: :system do
  # いいね！が機能し正しくカウントと表示をすること
  scenario 'like and unlike' do
    user = create(:user, :with_posts)
    user1 = create(:user, :with_posts)

    aggregate_failures do
      sign_in_as(user)
      visit user_path(user1)
      expect(current_path).to eq user_path(user1)
      expect(page).to have_link "いいね! (#{user1.likes.count})"
      expect(page).to have_content 'いいね数'
      click_on user1.posts.first.title
      expect(current_path).to eq post_path(user1.posts.first)
      expect do
        find('#like').click
        visit current_path
      end.to change(user.likes, :count).by(1)
      expect(page).to have_css '#unlike'

      visit user_path(user)
      expect(page).to have_link "いいね! (#{user.likes.count})"
      click_on "いいね! (#{user.likes.count})"
      expect(current_path).to eq like_path(user)
      expect(page).to have_content user1.posts.first.content
      post = user1.posts.first
      expect(page).to have_content "いいね数 #{Like.where(post_id: post.id).count}"

      visit user_path(user1)
      click_on user1.posts.first.title
      expect do
        find('#unlike').click
        visit current_path
      end.to change(user.likes, :count).by(-1)
      expect(page).to have_css '#like'
    end
  end
end
