# frozen_string_literal: true

module UsersHelper
  # Gravatar URLs are based on an MD5 hash of the user’s email address
  def gravatar_for(user, size: 80)
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
