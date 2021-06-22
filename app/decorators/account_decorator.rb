# frozen_string_literal: true

class AccountDecorator < ApplicationDecorator
  delegate_all

  def account_avatar
    # avatar.attached? ? h.url_for(avatar) : 'default_avatar.png'
    avatar_url.presence || 'default_avatar.png'
  end

  def login_name
    user.present? ? user.first_name : (username || 'account')
  end

  def account_roles
    roles.map(&:display_name).join(', ')
  end
end
