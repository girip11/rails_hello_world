# frozen_string_literal: true

require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  def page_title(page_name = "")
    base_title = "Ruby on Rails Sample App"
    page_name.empty? ? base_title : "#{page_name} | #{base_title}"
  end

  test "should point root to home page" do
    get root_url
    assert_response :success
    assert_select "title", self.page_title
  end

  test "should get home" do
    get static_pages_home_url
    assert_response :success
    assert_select "title", self.page_title
  end

  test "should get help" do
    get static_pages_help_url
    assert_response :success
    assert_select "title", self.page_title("Help")
  end

  test "should fetch about" do
    get static_pages_about_url
    assert_response :success
    assert_select "title", self.page_title("About")
  end
end
