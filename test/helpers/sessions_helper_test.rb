# frozen_string_literal: true

require "test_helper"

# Command for running this test alone
# bundle exec rails test -n /ApplicationHelperTest/ -v
class SessionsHelperTest < ActionView::TestCase
  def setup
    @user = users(:jane)
  end

  test "current user is valid when session is nil and user is remembered" do
    remember(@user)
    assert_equal @user, current_user
    assert is_logged_in?
  end

  test "current user is invalid when remember digest is incorrect" do
    # This would have set the remember_digest in the user
    remember(@user)

    # Updates the digest token
    @user.remember
    assert current_user.nil?
    assert_not logged_in?
  end
end
