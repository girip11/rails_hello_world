# frozen_string_literal: true

require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:john)
    @non_admin = users(:jane)
  end

  test "index should do pagination" do
    log_in_as(@non_admin.email)

    get users_path
    assert_template "users/index"

    # checks for page navigation at the top and bottom
    assert_select "div.pagination", count: 2

    User.paginate(page: 1).each do |user|
      assert_select "a[href=?]", user_path(user), text: user.name
    end
  end

  test "index as non admin" do
    # verify user login
    log_in_as(@non_admin.email)
    follow_redirect!
    assert_not(flash.empty?)
    assert(is_user_logged_in?(@non_admin.id))

    # visit users
    get users_path
    assert_select "a", text: "delete", count: 0
  end

  test "index as admin with pagination and delete links" do
    # verify user login
    log_in_as(@admin.email)
    follow_redirect!
    assert_not(flash.empty?)
    assert(is_user_logged_in?(@admin.id))

    # visit users
    get users_path
    assert_template "users/index"
    assert_select "div.pagination"
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select "a[href=?]", user_path(user), text: user.name
      assert_select "a[href=?]", user_path(user), text: "delete" unless user == @admin
    end

    assert_difference("User.count", -1) { delete user_path(@non_admin) }
  end
end
