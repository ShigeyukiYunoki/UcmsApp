require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    assert_equal session[:forwarding_url], "http://www.example.com"+edit_user_path(@user)
    log_in_as(@user)
    # assert_template 'users/edit'
    assert_redirected_to edit_user_path(@user)
    assert_nil session[:forwarding_url]
    name = "foo bar"
    email = "foo@bar.com"
    patch user_path(@user),params: { user: { name:  name,
                                              email: email,
                                              seriousness: "sss",
                                              password:              "",
                                              password_confirmation: "" } }
    # assert_template 'users/edit'
    # assert_select 'div.alert', count: 4
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email

  end

end
