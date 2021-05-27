require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "layout links" do
    get top_path
    assert_template 'home/top0'
    assert_select "a[href=?]", top_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", new_user_path
    get login_path
    assert_select "title", full_title("Login")
    get new_user_path
    assert_select "title", full_title("Signup")

    log_in_as(@user)
    get top_path
    assert_template 'home/top0'
    assert_select "a[href=?]",top_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", logout_path

  end

end
