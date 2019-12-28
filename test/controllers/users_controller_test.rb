# frozen_string_literal: true

require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  test "should get new" do
    get signup_path
    assert_response :success
    assert_select "title", page_title("Signup")
  end
end
