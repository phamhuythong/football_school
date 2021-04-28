# frozen_string_literal: true

class UserDecorator < ApplicationDecorator
  delegate_all

  def user_avatar
    # avatar.attached? ? h.url_for(avatar) : 'default_avatar.png'
    image_url.present? ? image_url : 'default_avatar.png'
  end
end
