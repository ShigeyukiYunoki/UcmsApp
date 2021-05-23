require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    # １行目の最後に","が必要！2行目の最初だと文法エラーになる！
    @user = User.new(name: "Example User", email: "user@example.com",
                seriousness: "軽症", password: "foooobar", password_confirmation: "foooobar")
    # has_secure_passwordには、仮想的なpassword属性とpassword_confirmation属性に対して
    # バリデーションをする機能も（強制的に）追加されている
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = ""
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = ""
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.name = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
      valid_addresses.each do |valid_address|
        @user.email = valid_address
        assert @user.valid?, "#{valid_address.inspect} should be valid"
      end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup #同じ属性を持つデータを複製するためのメソッド
    # duplicate_user.email = @user.email.upcase
    # 通常メールアドレスは大文字小文字を区別しないので、大文字を区別せずにテストする
    # emailは小文字で保存されるため大文字を区別しないテストは不要となる
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 8
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 7
    assert_not @user.valid?
  end

  test "seriousness should be present" do
    @user.seriousness = ""
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember,"")
  end

  test "associated posts should be destroyed" do
    @user.save
    @user.posts.create!(title:"good",content:"superrrr!!",
          start_time: Time.zone.now)
    assert_difference 'Post.count',-1 do
    @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    michael = users(:michael)
    archer = users(:archer)
    assert_not michael.following?(archer)
    michael.follow(archer)
    assert michael.following?(archer)
    assert archer.followers.include?(michael)
    michael.unfollow(archer)
    assert_not michael.following?(archer)
  end

  test "feed should have the right posts" do
    michael = users(:michael)
    archer = users(:archer)
    lana = users(:lana)
    lana.posts.each do |post_following|
      assert michael.feed.include?(post_following)
    end
    michael.posts.each do |post_self|
      assert michael.feed.include?(post_self)
    end
    archer.posts.each do |post_unfollowed|
      assert_not michael.feed.include?(post_unfollowed)
    end
  end

end
