# frozen_string_literal: true

class StaticPagesController < ApplicationController
  attr_reader :title

  def page_title(page_name)
    "#{page_name} | Ruby on Rails Sample App"
  end

  def home
    @title = page_title("Home")
  end

  def help
    @title = page_title("Help")
  end

  def about
    @title = page_title("About")
  end
end
