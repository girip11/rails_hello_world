# frozen_string_literal: true
require "test_helper"

class UserSignupTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "User should not be created" do
    # To check if the sign up form is rendered correctly
    get signup_path

    # this way is cleaner than storing and comparing before and after counts
    assert_no_difference "User.count" do
      # In versions of Rails before 5, params was implicit, and
      # only the user hash would be passed. This practice was deprecated
      # in Rails 5.0, and now the recommended method is to
      # include the full params hash explicitly
      post users_path,
           params: {
             user: {
               name: "",
               email: "jane@example.com",
               password: "foobar",
               password_confirmation: "foobar",
             },
           }
    end

    assert_template "users/new"
  end

  test "User should be created" do
    # To check if the sign up form is rendered correctly
    get signup_path

    # this way is cleaner than storing and comparing before and after counts
    assert_difference "User.count", 1 do
      post users_path,
           params: {
             user: {
               name: "jacob",
               email: "jacob@example.com",
               password: "foobar",
               password_confirmation: "foobar",
             },
           }
    end
    follow_redirect!
    # assert_template "users/show"
    # assert_not flash.empty?
    # assert is_logged_in?
  end

  test "valid signup information with account activation" do
    get signup_path
    assert_difference "User.count", 1 do
      post users_path,
           params: {
             user: {
               name: "Example User",
               email: "user@example.com",
               password: "password",
               password_confirmation: "password",
             },
           }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    # Try to log in before activation.
    log_in_as(user)
    assert_not is_logged_in?
    # Invalid activation token
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    # Valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: "wrong")
    assert_not is_logged_in?
    # Valid activation token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template "users/show"
    assert is_logged_in?
  end
end
