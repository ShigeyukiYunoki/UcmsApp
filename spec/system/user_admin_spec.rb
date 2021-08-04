require 'rails_helper'

RSpec.describe 'UserAdmin', type: :system, js: true do
  # 管理者にはindexページの各有効化済みのユーザー毎に削除linkが表示されユーザーを削除できる
  scenario 'index as admin including pagination and delete links' do
    admin = create(:user, admin: true)
    non_admin1 = create(:user)
    non_admin2 = create(:user)
    non_activated = create(:user, activated: false, activated_at: nil)

    sign_in_as(admin)
    visit users_path
    expect(current_path).to eq users_path
    aggregate_failures do
      expect(page).to have_css 'ul.pagination', count: 2
      expect(page).to have_link admin.name
      expect(page).to have_link non_admin1.name
      expect(page).to have_link non_admin2.name
      expect(page).to_not have_link non_activated.name
      expect(first('li')).to_not have_link '削除'
      expect(page).to have_link '削除'
      expect do
        page.accept_confirm do
          click_on '削除', match: :first
        end
        expect(page).to have_current_path users_path
        expect(page).to have_content 'ユーザーは削除されました'
      end.to change(User, :count).by(-1)

      click_on 'ログアウト'
      sign_in_as(non_admin2)
      visit users_path
      expect(page).to_not have_link '削除'
    end
  end
  # 有効化していないユーザーはindexページに表示されず有効化するまでログインできない
  scenario 'non-activated-user is not in index and redirect top' do
    activated = create(:user)
    non_activated = create(:user, activated: false, activated_at: nil)
    create(:user, activated: false, activated_at: nil)
    create(:user)
    sign_in_as(activated)
    expect(page).to have_content 'Good job!'
    visit users_path
    expect(page).to_not have_content non_activated.name
    click_on 'ログアウト'
    visit login_path
    expect(current_path).to eq login_path
    fill_in 'Email', with: non_activated.email
    fill_in 'Password', with: non_activated.password
    click_button 'ログイン'
    expect(page).to have_content 'アカウントは有効化されていません。アカウント有効化メールを確認してください。'
    expect(page).to have_current_path top_path
  end
end
