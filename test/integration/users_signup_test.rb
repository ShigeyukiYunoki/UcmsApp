require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test 'invalid signup information' do
    get new_user_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: '',
                                         email: 'user@invalid',
                                         password: 'foo',
                                         password_confirmation: 'bar' } }
    end
    assert_template 'users/new'
    # assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test 'valid signup information with account_activation' do
    get new_user_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: 'Example',
                                         email: 'user@exa.com',
                                         seriousness: 'jjdfdjf',
                                         password: 'password',
                                         password_confirmation: 'password' } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    # Usersコントローラのcreateアクションで定義されているインスタンス変数@user
    # テストでassigns(:user)と書くと@userにアクセスできるようになる
    assert_not user.activated?

    log_in_as(user)
    assert_not logged_in?

    get edit_account_activation_path('invalid_token', email: user.email)
    assert_not logged_in?

    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not logged_in?

    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?

    follow_redirect!
    assert_template 'users/show'
    assert_not flash.blank?
    assert logged_in?
  end
end
