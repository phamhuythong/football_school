# frozen_string_literal: true

class AccountDecorator < ApplicationDecorator
  delegate_all

  def account_avatar
    # avatar.attached? ? h.url_for(avatar) : 'default_avatar.png'
    avatar_url.present? ? avatar_url : 'default_avatar.png'
  end

  def account_roles
    roles.map(&:name).join(', ')
  end
end
