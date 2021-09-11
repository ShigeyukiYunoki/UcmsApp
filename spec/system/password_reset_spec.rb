require 'rails_helper'

RSpec.describe 'PasswordReset', type: :system do
  include ActiveJob::TestHelper
  # パスワードをリセットする
  scenario 'user resets the password' do
    user = create(:user)
    aggregate_failures do
      visit login_path
      click_link 'パスワード？'
      expect(current_path).to eq new_password_reset_path
      # メールアドレスが正しくない場合
      fill_in 'Email', with: 'pass@email.com'
      expect { click_button '送信' }.to change { ActionMailer::Base.deliveries.size }.by(0)
      expect(page).to have_content 'メールアドレスが存在しません'
      expect(current_path).to eq password_resets_path
      # メールアドレスが正しい場合
      fill_in 'Email', with: user.email
      expect { click_button '送信' }.to change { ActionMailer::Base.deliveries.size }.by(1)
      user.create_reset_digest
      expect(page).to have_content 'パスワード再設定メールを送信しました'
      expect(current_path).to eq top_path
      mail = ActionMailer::Base.deliveries.last
      expect(mail.to).to eq [user.email]
      expect(mail.from).to eq ['noreply@example.com']
      expect(mail.subject).to eq 'パスワードの再設定'
      expect(mail.html_part.body).to match 'パスワードをリセットするには下記のlinkをクリックしてください。'
      expect(mail.html_part.body).to match 'Reset password'
      # expect(mail.html_part.body).to match user.reset_token
      # def reset_url(mail)
      #   body = mail.body.encoded
      #   body[/http[^"]+/]
      # end
      # url = reset_url(mail)
      # visit url

      # トークンが正しくない場合
      visit edit_password_reset_path('wrong token', email: user.email)
      expect(current_path).to eq top_path
      # メールアドレスが正しくない場合
      visit edit_password_reset_path(user.reset_token, email: '')
      expect(current_path).to eq top_path
      # ユーザーが認証されてない場合
      user.toggle!(:activated)
      visit edit_password_reset_path(user.reset_token, email: user.email)
      expect(current_path).to eq top_path
      user.toggle!(:activated)
      # トークンとメールアドレスが正しい場合
      visit edit_password_reset_path(user.reset_token, email: user.email)
      expect(current_path).to eq edit_password_reset_path(user.reset_token)
      expect(page).to have_field 'パスワード'
      expect(page).to have_field 'パスワードの確認'
      # パスワードが一致しない場合
      fill_in 'パスワード', with: 'password'
      fill_in 'パスワードの確認', with: 'pass'
      click_on '更新'
      expect(current_path).to eq password_reset_path(user.reset_token)
      expect(page).to have_content '確認とパスワードの入力が一致しません'
      # 入力がない場合
      fill_in 'パスワード', with: ''
      fill_in 'パスワードの確認', with: ''
      click_on '更新'
      expect(current_path).to eq password_reset_path(user.reset_token)
      expect(page).to have_content 'パスワードを入力してください'
      # パスワードの入力が正しい場合
      fill_in 'パスワード', with: 'fooobbar'
      fill_in 'パスワードの確認', with: 'fooobbar'
      click_on '更新'
      expect(current_path).to eq user_path(user)
      expect(page).to have_content 'パスワードは更新されました！'
    end
  end
  # パスワードリセットの有効期限が切れている
  scenario 'expired token' do
    user = create(:user)
    visit login_path
    click_link 'パスワード？'
    fill_in 'Email', with: user.email
    user.create_reset_digest
    visit edit_password_reset_path(user.reset_token, email: user.email)
    user.update_attribute(:reset_sent_at, 3.hours.ago)
    fill_in 'パスワード', with: 'fooobbar'
    fill_in 'パスワードの確認', with: 'fooobbar'
    click_on '更新'
    expect(current_path).to eq new_password_reset_path
    expect(page).to have_content '有効期限が切れました'
  end
end
