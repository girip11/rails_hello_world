# frozen_string_literal: true

require "test_helper"

# Command for running this test alone
# bundle exec rails test -n /ApplicationHelperTest/ -v
class ApplicationHelperTest < ActionView::TestCase
  test "page title helper" do
    assert_equal page_title, ApplicationHelper::BASE_TITLE
    assert_equal page_title("Hello"), "Hello | #{ApplicationHelper::BASE_TITLE}"
  end
end
