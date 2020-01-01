# frozen_string_literal: true
require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user =
      User.new(
        name: "Jacob",
        email: "jacob@example.com",
        password: "foobar",
        password_confirmation: "foobar",
      )
  end

  test "model should be valid" do
    assert @user.valid?
  end

  test "User should have a name" do
    @user.name = ""
    assert_not @user.valid?
  end

  test "User should have an email" do
    @user.email = ""
    assert_not @user.valid?
  end

  test "User should have a password" do
    @user.password = @user.password_confirmation = ""
    puts @user.valid?
    assert_not @user.valid?
  end

  test "User should have a password and password confirmation the same" do
    @user.password_confirmation = "barfoo"
    assert_not @user.valid?
  end

  test "User name should have a max length of 50" do
    @user.name = "john" * 20
    assert_not @user.valid?
  end

  test "User email should have a maximum length of 255" do
    @user.email = "john" * 100 + "@example.com"
    assert_not @user.valid?
  end

  test "User should have a password of minimum length 6 and not blank" do
    @user.password = @user.password_confirmation = " " * 5
    assert_not @user.valid?

    @user.password = @user.password_confirmation = "f" * 5
    assert_not @user.valid?
  end

  test "User should have a password of maximum length 15" do
    @user.password = @user.password_confirmation = "f" * 20
    assert_not @user.valid?
  end

  test "User email should accept valid email addresses" do
    valid_emails = %w[
      user@example.com
      USER@foo.COM
      A_US-ER@foo.bar.org
      first.last@foo.jp
      alice+bob@baz.cn
    ]
    valid_emails.each do |email|
      @user.email = email
      assert @user.valid?, "#{email} should be valid"
    end
  end

  test "User email should reject invalid email addresses" do
    invalid_emails = %w[
      user@example,com
      user_at_foo.org
      user.name@example.
      foo@bar_baz.com
      foo@bar+baz.com
    ]
    invalid_emails.each do |email|
      @user.email = email
      assert_not @user.valid?, "#{email} should be invalid"
    end
  end

  test "User email should be unique" do
    begin
      dup_user = @user.dup
      @user.save

      # user should be invalid even with different case email ids
      dup_user.email = dup_user.email.upcase
      assert_not dup_user.valid?
    rescue StandardError => e
      puts e.message
      raise e
    ensure
      @user.destroy if @user.persisted?
    end
  end

  test "User email should be stored in lowercase only" do
    @user.email = @user.email.upcase
    begin
      @user.save
      reloaded_user = @user.reload
      puts reloaded_user.email
      assert_equal reloaded_user.email, @user.email.downcase
    rescue StandardError => e
      puts e.message
      raise e
    ensure
      @user.destroy if @user.persisted?
    end
  end

  test "authenticated? should return false for logged out user" do
    @user = users(:jane)

    # remember_me
    @user.remember
    remember_token = @user.remember_token
    assert @user.authenticated?(remember_token)

    # forget user and then validate
    @user.forget
    assert_not @user.authenticated?(remember_token)
  end
end
