require 'test_helper'

class PostTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    @post = @user.posts.build(title:"good",content:"superrrr!!",
          start_time: Time.zone.now, user_id: @user.id)
  end

  test "should be valid" do
    assert @post.valid?
  end

  test "user id should be present" do
    @post.user_id = nil
    assert_not @post.valid?
  end

  test "content should be valid" do
    @post.content = " "
    assert_not @post.valid?
  end

  test "content should be most 300 characters" do
    @post.content = "a" * 301
    assert_not @post.valid?
  end

  # test "order should be most recent first" do
  #   assert_equal posts(:most_recent), Post.last
  # end

end
