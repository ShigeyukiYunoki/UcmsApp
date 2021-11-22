require 'rails_helper'

RSpec.describe 'TopLayout', type: :system, js: true do
  # ログイン前後のtopページの変化
  scenario 'top layout changes if login' do
    user = create(:user, :with_posts)
    user1 = create(:user, :with_posts)
    user2 = create(:user, :with_posts)

    visit top_path
    aggregate_failures do
      expect(page).to have_link 'ログイン'
      expect(page).to have_link '新規登録'

      sign_in_as(user)
      user.follow(user1)
      user.follow(user2)
      visit top_path
      expect(current_path).to eq top_path
      expect(page).to have_link user.name
      expect(page).to have_link user1.name
      expect(page).to have_link user2.name
      expect(page).to have_link 'UcmsAppとは'
      expect(page).to have_link 'ユーザー一覧'
      expect(page).to have_link 'ログアウト'
      # フォローしているユーザーのpostが表示されているか
      user1.posts.each do |post|
        expect(page).to have_content post.title
      end
      user2.posts.each do |post|
        expect(page).to have_content post.title
      end

      user.feed.page(0).each do |post|
        expect(page).to have_content post.title
      end
    end
  end
end
