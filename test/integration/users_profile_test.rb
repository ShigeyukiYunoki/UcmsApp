require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test 'profile display' do
    log_in_as(@user)
    # loginしていないとtestがerrorに
    # FAIL["test_profile_display", #<Minitest::Reporters::Suite:0x00007fe9d85897f0
    # @name="UsersProfileTest">]
    # test_profile_display#UsersProfileTest (0.32s)
    # expecting <"users/show"> but rendering with <[]>
    # test/integration/users_profile_test.rb:11:in `block in <class:UsersProfileTest>'
    get user_path @user
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h3', @user.name
    assert_select 'img.gravatar'
    assert_match @user.posts.count.to_s, response.body
    assert_select 'ul.pagination', 2
    @user.posts.page(2).each do |post|
      assert_match post.content, response.body
    end
    assert_match @user.following.count.to_s, response.body
    assert_match @user.followers.count.to_s, response.body
  end
end
