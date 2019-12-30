# frozen_string_literal: true

require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  test "should get new" do
    get login_path
    assert_response :success
    assert_select "title", page_title("Login")
  end
end
