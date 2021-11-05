require 'rails_helper'

RSpec.describe 'Signup', type: :system, js: true do
  include ActiveJob::TestHelper
  # ユーザは新規登録する
  scenario 'user successfully signs up' do
    visit new_user_path
    aggregate_failures do
      expect do
        fill_in 'ユーザー名', with: 'こ こうじ'
        fill_in 'メールアドレス', with: 'kou@example.com'
        select '軽症', from: '重症度'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワードの確認', with: 'password'
        expect { click_button '新規登録' }.to change { ActionMailer::Base.deliveries.size }.by(1)
      end.to change(User, :count).by(1)
      expect(page).to have_content 'アカウント有効化メールを確認してください'
      expect(current_path).to eq top_path
      # user = User.last
      # @user.activation_token = User.new_token
      # @user.activation_digest = User.digest(@user.activation_token)
      mail = ActionMailer::Base.deliveries.last
      expect(mail.to).to eq ['kou@example.com']
      expect(mail.from).to eq ['noreply@www.ucmsapp.com']
      expect(mail.subject).to eq 'アカウントの有効化'
      expect(mail.html_part.body).to match 'Ucmsappにようこそ！下記のlinkをクリックしてアカウントを有効化してください。'
      expect(mail.html_part.body).to match 'Activate'
      # expect(mail.html_part.body).to match user.activation_token
      # token = user.activation_token

      # def activation_url(mail)
      #  body = mail.body.encoded
      #  body[/http[^"]+/]
      # end
      # url = activation_url(mail)
      # visit url

      # visit edit_account_activation_path(user.activation_token, email: user.email)
      # expect(current_path).to eq user_path(user)
      # expect(page).to have_content 'アカウントは有効化されました'
    end
  end
  # ユーザーは新規登録できない
  scenario 'user unsuccessfully signs up' do
    visit new_user_path
    aggregate_failures do
      expect do
        fill_in 'ユーザー名', with: 'jjj'
        fill_in 'メールアドレス', with: 'kou@example...com'
        select '軽症', from: '重症度'
        fill_in 'パスワード', with: 'foo'
        fill_in 'パスワードの確認', with: 'bar'
        click_button '新規登録'
      end.to change(User, :count).by(0)

      expect(page).to have_current_path users_path
      expect(page).to have_content 'メールアドレスは不正な値です'
      expect(page).to have_content '確認とパスワードの入力が一致しません'
      expect(page).to have_content 'パスワードは8文字以上で入力してください'
    end
  end
end
