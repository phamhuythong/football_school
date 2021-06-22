# frozen_string_literal: true

class UserDecorator < ApplicationDecorator
  delegate_all

  def user_avatar
    # avatar.attached? ? h.url_for(avatar) : 'default_avatar.png'
    if avatar_url.present?
      avatar_url
    else
      (account&.avatar_url.presence || 'default_avatar.png')
    end
  end
end
