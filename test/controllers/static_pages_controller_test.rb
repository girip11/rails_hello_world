# frozen_string_literal: true

require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  test "should point root to home page" do
    get root_path
    assert_response :success
    assert_select "title", page_title
  end

  test "should get home" do
    get root_path
    assert_response :success
    assert_select "title", page_title
  end

  test "should get help" do
    get help_path
    assert_response :success
    assert_select "title", page_title("Help")
  end

  test "should fetch about" do
    get about_path
    assert_response :success
    assert_select "title", page_title("About")
  end

  test "should fetch contact" do
    get contact_path
    assert_response :success
    assert_select "title", page_title("Contact")
  end
end
