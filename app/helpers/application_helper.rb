# frozen_string_literal: true

module ApplicationHelper
  BASE_TITLE = "Ruby on Rails Sample App"

  def page_title(page_name = "")
    if page_name.empty?
      ApplicationHelper::BASE_TITLE
    else
      "#{page_name} | #{ApplicationHelper::BASE_TITLE}"
    end
  end
end
