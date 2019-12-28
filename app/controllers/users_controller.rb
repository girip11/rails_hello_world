# frozen_string_literal: true

# NOTE: Helper modules should be included explicitly
class UsersController < ApplicationController
  include ApplicationHelper

  def new
    @title = page_title("Signup")
  end
end
