require 'test_helper'

class PostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test 'posts interface' do
    log_in_as(@user)
    get user_path(@user)
    assert_select 'ul.pagination', 2
    get "/posts/#{@user.id}/index?start_date=#{Date.today.strftime('%Y-%m-%d')}"
    get new_post_path(@user)
    assert_select 'input[type=file]'

    assert_no_difference 'Post.count' do
      post posts_path, params: { post: { content: '' } }
    end
    assert_select 'div#error_explanation'

    title = 'jsdifjs'
    content = 'jdoifjowpjfiowejfioe'
    start_time = Date.today
    image = fixture_file_upload('test/fixtures/kitten.jpg', 'image/jpeg')
    assert_difference 'Post.count', 1 do
      post posts_path, params: { post:
        { title: title, content: content, start_time: start_time, image: image } }
    end
    assert assigns(:post).image.attached?
    @post = @user.posts.find_by(title: 'jsdifjs')
    assert_redirected_to "/posts/#{@user.id}/index?start_date=#{@post.start_time.strftime('%Y-%m-%d')}"
    follow_redirect!
    assert_match title, response.body

    get user_path(@user)
    assert_select 'a', text: '削除'
    first_post = @user.posts.page(1).first
    assert_difference 'Post.count', -1 do
      delete post_path(first_post)
    end

    get user_path(users(:archer))
    assert_select 'a', text: '削除', count: 0
  end
end
