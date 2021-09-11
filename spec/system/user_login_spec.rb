require 'rails_helper'

RSpec.describe "UserLogin", type: :system do
  # ユーザーはログインする
  scenario 'login with valid info' do
    user = create(:user)
    visit login_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    expect(page).to have_field('記憶する')
    click_button 'ログイン'
    expect(page).to have_current_path user_path(user)
    expect(page).to have_link 'ログアウト'
    expect(page).to_not have_link 'ログイン'
    expect(page).to have_link user.name
    find('.swal-button--gotit').click
    click_on 'ログアウト'
    expect(page).to have_content 'ログアウトしました'
    expect(current_path).to eq login_path
    expect(page).to_not have_link 'ログアウト'
    expect(page).to have_link 'ログイン'
    expect(page).to_not have_link user.name
  end

  # ログインできない
  scenario 'login with valid email/invalid password' do
    user = create(:user)
    visit login_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'invalid'
    click_button 'ログイン'
    expect(current_path).to eq login_path
    expect(page).to have_content 'メールアドレスまたはパスワードが違います'
  end

  # ユーザーのログイン永続化
  scenario 'login with remembering' do
    user = create(:user)
    aggregate_failures do
      # ログイン永続化する
      visit login_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      check 'session[remember_me]'
      click_button 'ログイン'
      find('.swal-button--gotit').click
      expect(page).to have_link 'ログアウト'
      show_me_the_cookies
      # テストブラウザにあるsessionのためのcookieと期限切れのcookieをとり除いてくれる。
      # ブラウザの再起動状態を実現する
      expire_cookies
      visit current_path
      show_me_the_cookies
      expect(page).to have_link 'ログアウト'
      click_on 'ログアウト'
      # ログイン永続化しない
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      uncheck 'session[remember_me]'
      expect(page).to have_unchecked_field('記憶する')
      click_button 'ログイン'
      expect(page).to have_link 'ログアウト'
      expire_cookies
      visit current_path
      show_me_the_cookies
      expect(page).to have_content 'ログインが必要です'
      expect(page).to_not have_link 'ログアウト'
      expect(page).to have_link 'ログイン'
    end
  end
end
