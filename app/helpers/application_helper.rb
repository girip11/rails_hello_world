# frozen_string_literal: true

module ApplicationHelper
  def page_title(page_name = "")
    base_title = "Ruby on Rails Sample App"
    page_name.empty? ? base_title : "#{page_name} | #{base_title}"
  end
end
