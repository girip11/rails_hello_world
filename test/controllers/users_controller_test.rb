# frozen_string_literal: true

require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:john)
    @other_user = users(:jane)
  end

  test "should get new" do
    get signup_path
    assert_response :success
    assert_select "title", page_title("Signup")
  end

  test "should be redirected to login page on edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should be redirected to login page on update when not logged in" do
    patch user_path(@user),
          params: {
            user: {
              name: "foo bar",
              email: "foobar@example.com",
              password: "123456",
              password_confirmation: "123456",
            },
          }
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should be redirected when trying to edit the wrong user" do
    log_in_as(@other_user.email)
    # Follow the redirect so that the flash gets rendered
    follow_redirect!
    get edit_user_path(@user)
    assert_redirected_to root_path
    assert flash.empty?
  end

  test "should be redirected when trying to update wrong user" do
    log_in_as(@other_user.email)
    # So that the flash gets rendered
    follow_redirect!

    patch user_path(@user),
          params: {
            user: {
              name: "foo bar",
              email: "foobar@example.com",
              password: "123456",
              password_confirmation: "123456",
            },
          }
    assert flash.empty?
    assert_redirected_to root_path
  end

  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_path
  end

  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user.email)
    follow_redirect!

    assert_not @other_user.admin?

    patch user_path(@other_user),
          params: {
            user: {
              name: @other_user.name,
              email: @other_user.email,
              password: "",
              password_confirmation: "",
              admin: true,
            },
          }

    assert_not @other_user.reload.admin?
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference("User.count") { delete user_path(@other_user) }

    assert_redirected_to(login_path)
    assert_not(flash.empty?)
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user.email)
    follow_redirect!
    assert_not(flash.empty?) # login flash
    # Below verifies that the user logged in successfully
    assert(is_user_logged_in?(@other_user.id))

    assert_no_difference("User.count") { delete user_path(@user) }
    assert_redirected_to(root_path)
  end
end
