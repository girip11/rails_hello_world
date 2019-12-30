# frozen_string_literal: true

require "test_helper"

# To run single test file use either of the below commands
# bundle exec rails test -n /UsersLoginTest/ -v
# or
# bundle exec rails test test/integration/users_login_test.rb -v

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    #users correspond to users.yml
    @user = users(:john)
  end

  test "login with invalid information" do
    get login_path
    assert_template "sessions/new"

    post login_path params: { session: { email: "nouser@example.com", password: "foobar" } }

    assert_template "sessions/new"
    assert_equal flash.empty?, false

    get root_path
    assert flash.empty?
  end

  # required user for logging in is automatically created by the user in the fixture users.yml
  test "login with valid information and logout" do
    get login_path
    assert_template "sessions/new"

    # login action
    post login_path params: { session: { email: @user.email, password: "password" } }
    assert is_logged_in?

    assert_redirected_to @user
    follow_redirect!
    assert_template "users/show"

    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path, count: 1
    assert_select "a[href=?]", user_path(@user), count: 1

    # logout action
    delete logout_path
    assert_not is_logged_in?

    assert_redirected_to root_path
    follow_redirect!
    assert_template "static_pages/home"

    assert_select "a[href=?]", login_path, count: 1
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
end
