# frozen_string_literal: true
require "test_helper"

class UserSignupTest < ActionDispatch::IntegrationTest
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
               name: "jane",
               email: "jane@example.com",
               password: "foobar",
               password_confirmation: "foobar",
             },
           }
    end
    follow_redirect!
    assert_template "users/show"
    assert_not flash.empty?
  end
end
