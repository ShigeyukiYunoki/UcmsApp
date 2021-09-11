require 'rails_helper'

RSpec.describe 'PostsInterfaces', type: :system do
  # ユーザーは新たな投稿を作成する
  scenario 'user create a new post' do
    user = create(:user)
    # post = create(:post)

    visit login_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'ログイン'
    expect(page).to have_current_path user_path(user)
    find('.swal-button--gotit').click
    visit top_path
    click_on '日記をかく'
    aggregate_failures do
      expect do
        fill_in 'タイトル', with: 'title'
        fill_in '投稿内容', with: 'content'
        attach_file 'post_image', "#{Rails.root}/spec/factories/kitten.jpg"
        click_button '投稿'
      end.to change(user.posts, :count).by(1)

      post = Post.last
      expect(page).to have_current_path top_path
      expect(page).to have_content '投稿完了！'
      expect(page).to have_content post.title
      expect(page).to have_content post.content
      expect(page).to have_content post.start_time.strftime('%Y/%m/%d')
      expect(page).to have_css('img')
      expect(page).to have_css('ul.pagination', count: 2)
    end
  end

  # imageはjpeg,gif,pngのみ対応
  scenario 'image only jpeg,gif and png' do
    user = create(:user)
    sign_in_as(user)
    visit top_path
    click_on '日記をかく'
    aggregate_failures do
      expect do
        fill_in 'タイトル', with: 'title'
        fill_in '投稿内容', with: 'content'
        attach_file 'post_image', "#{Rails.root}/spec/factories/1292866.svg"
        click_button '投稿'
      end.to change(user.posts, :count).by(0)
      expect(page).to have_content 'はjpeg,gif,pngのみ対応しています'
      expect(page).to have_current_path '/posts'
    end
  end
  # アップロード可能なファイルサイズは5MBまで
  scenario 'image less than 5MB' do
    user = create(:user)
    sign_in_as(user)
    visit top_path
    click_on '日記をかく'
    aggregate_failures do
      page.accept_confirm('アップロード可能なファイルサイズは5MBまでです。より小さいサイズのファイルを選んでください。') do
        fill_in 'タイトル', with: 'title'
        fill_in '投稿内容', with: 'content'
        attach_file 'post_image', "#{Rails.root}/spec/factories/1296_autumn_kouyou_momiji_sky_9948.jpg"
      end
      expect(page).to have_current_path new_post_path
    end
  end

  # ユーザーは自分の投稿を削除する
  scenario 'user delete own post' do
    user = create(:user)
    post = create(:post)

    sign_in_as(user)
    create_post(post)
    expect(page).to have_content '投稿完了！'
    expect do
      page.accept_confirm do
        click_on '削除', match: :first
      end
      expect(page).to have_current_path top_path
      expect(page).to have_content '削除しました'
    end.to change(user.posts, :count).by(-1)
  end
  # 別のユーザーの投稿の編集、削除リンクは表示されない
  scenario 'edit and delete link not show on other users post' do
    user = create(:user)
    post = create(:post)
    other_user = create(:user)
    other_post = create(:post)
    sign_in_as(user)
    create_post(post)
    click_on 'ログアウト'
    sign_in_as(other_user)
    create_post(other_post)
    visit user_path(user)
    aggregate_failures do
      expect(page).to_not have_content '編集'
      expect(page).to_not have_content '削除'
    end
  end
end
