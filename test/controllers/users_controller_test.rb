require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
    @non_activated = users(:non_activated)
  end

  test 'should get new' do
    get new_user_path
    assert_response :success
  end

  test 'should redirect edit when not logged in' do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test 'should redirect update when not logged in' do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test 'should not allow the admin attribute to be edited via the web' do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: { user: { password: 'password',
                                                    password_confirmation: 'password',
                                                    admin: true } }
    assert_not @other_user.reload.admin?
  end

  test 'should redirect edit when logged in as a wrong user' do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to @other_user
  end

  test 'should redirect update when logged in as a wrong user' do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to @other_user
  end

  test 'should redirect index when not logged in' do
    get users_path
    assert_redirected_to login_path
  end

  test 'should redirect destroy when not logged in' do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_path
  end

  test 'should redirect destroy when logged in as a non-admin' do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to top_path
  end

  test 'should not be non-activated-user in index and redirect show' do
    log_in_as(@user)
    get users_path
    assert_select 'a[href=?]', user_path(@non_activated), count: 0
    log_in_as(@non_activated)
    get user_path(@non_activated)
    assert_redirected_to top_path
  end

  test 'should redirect following when not logged in' do
    get following_user_path(@user)
    assert_redirected_to login_path
  end

  test 'should redirect followers when not logged in' do
    get followers_user_path(@user)
    assert_redirected_to login_path
  end
end
