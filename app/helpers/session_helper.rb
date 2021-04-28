# frozen_string_literal: true

module SessionHelper
  def log_in(account)
    session[:account_id] = account.id
  end

  def logged_in?
    current_user.present?
  end

  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  def require_login
    return if current_user

    store_location
    redirect_to login_url
  end
end
