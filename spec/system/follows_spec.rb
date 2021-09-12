require 'rails_helper'

RSpec.describe 'Follow', type: :system, js: true do
  # フォローが機能し正しくカウントと表示をすること
  scenario 'following and followed' do
    user = create(:user, :with_posts)
    user1 = create(:user, :with_posts)
    user2 = create(:user, :with_posts)
    aggregate_failures do
      sign_in_as(user)
      click_on 'ユーザー一覧'
      expect(current_path).to eq users_path
      click_on user1.name
      expect(current_path).to eq user_path(user1)
      click_on 'フォロー'
      visit current_path
      expect(page).to have_content "#{user1.followers.count} フォロワー"
      click_on 'ユーザー一覧'
      expect(current_path).to eq users_path
      click_on user2.name
      expect(current_path).to eq user_path(user2)
      click_on 'フォロー'
      visit current_path
      expect(page).to have_content "#{user2.followers.count} フォロワー"

      visit top_path
      expect(page).to have_content "#{user.following.count} フォロー"
      visit following_user_path(user)
      click_on 'フォロー'
      user.following.each do |userfollow|
        expect(page).to have_link userfollow.name
      end

      user1.follow(user)
      user2.follow(user)
      visit top_path
      click_on 'フォロワー'
      user.followers.each do |follower|
        expect(page).to have_link follower.name
      end

      visit user_path(user1)
      click_on 'フォロー解除'
      visit current_path
      expect(page).to have_content "#{user1.followers.count} フォロワー"
      visit user_path(user2)
      click_on 'フォロー解除'
      visit current_path
      expect(page).to have_content "#{user2.followers.count} フォロワー"

      visit top_path
      click_on 'フォロー'
      user.following.each do |userfollow|
        expect(page).to_not have_link userfollow.name
      end
    end
  end
end
