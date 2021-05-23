require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest

  def setup
    @base_title = "UcmsApp"

  end


  test "should get top" do
    get root_path
    assert_response :success
    assert_select "title","Home|#{@base_title}"
  end

  test "should get about" do
    get about_path
    assert_response :success
    assert_select "title","About|#{@base_title}"
  end

  test "should get login" do
    get login_path
    assert_response :success
    assert_select "title","Login|#{@base_title}"
  end


end
