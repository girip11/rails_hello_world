# frozen_string_literal: true

require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:jane)
  end

  test "User edit should not succeed" do
    log_in_as(@user.email, remember_me: "0")
    get edit_user_path(@user)

    assert_template "users/edit"

    patch user_path(@user),
          params: {
            user: {
              name: "", email: @user.email, password: "password", password_confirmation: "password"
            },
          }

    assert_template "users/edit"
  end

  test "User edit should succeed" do
    log_in_as(@user.email, remember_me: "0")
    get edit_user_path(@user)
    assert_template "users/edit"

    name = "Jane Marry Doe "
    patch user_path(@user),
          params: {
            user: { name: name, email: @user.email, password: "", password_confirmation: "" }
          }

    assert_not flash.empty?
    assert_redirected_to @user

    @user.reload
    assert_equal name, @user.name
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user.email)
    assert_redirected_to edit_user_path(@user)

    name = "Jane Mary Doe"
    patch user_path(@user),
          params: {
            user: { name: name, email: @user.email, password: "", password_confirmation: "" }
          }

    assert_not flash.empty?
    assert_redirected_to @user

    @user.reload
    assert_equal name, @user.name
  end
end
