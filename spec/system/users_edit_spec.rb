require 'rails_helper'

RSpec.describe 'UsersEdit', type: :system do
  # ログイン前にユーザー編集画面にアクセスするとログイン後にユーザー編集画面にアクセスする
  scenario 'successful edit with friendly forwarding' do
    user = create(:user)
    visit edit_user_path(user)
    sign_in_as(user)
    aggregate_failures do
      expect(current_path).to eq edit_user_path(user)
      # ユーザー情報が編集されて正しく表示されているか
      visit current_path
      fill_in 'ユーザー名', with: 'ぺ ぺろ'
      fill_in 'メールアドレス', with: 'p@p.com'
      select '重症', from: '重症度'
      fill_in 'パスワード', with: ''
      fill_in 'パスワードの確認', with: ''
      click_button '変更の保存'
      expect(page).to have_content 'ユーザー情報を編集しました'
      expect(current_path).to eq user_path(user)

      click_on 'プロフィールの編集'
      expect(current_path).to eq edit_user_path(user)
      visit edit_user_path(user)
      expect(page).to have_field 'ユーザー名', with: 'ぺ ぺろ'
      expect(page).to have_field 'メールアドレス', with: 'p@p.com'
      expect(page).to have_field '重症度', with: '重症'
      visit user_path(user)
      expect(page).to have_content 'ぺ ぺろ'
      expect(page).to have_content 'p@p.com'
      expect(page).to have_content '重症'
    end
  end
end
