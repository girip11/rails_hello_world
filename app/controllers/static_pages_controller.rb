# frozen_string_literal: true

class StaticPagesController < ApplicationController
  include ApplicationHelper

  def home
    @title = page_title
  end

  def help
    @title = page_title("Help")
  end

  def about
    @title = page_title("About")
  end

  def contact
    @title = page_title("Contact")
  end
end
