# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionHelper
  include Pundit

  before_action :require_login

  rescue_from Pundit::NotAuthorizedError, with: :show_fobbiden

  PAGE = 10

  # before_action :set_locale
  helper_method :current_user

  # def set_locale
  #   I18n.locale = params[:locale] || I18n.default_locale
  # end

  # def default_url_options
  #   { locale: I18n.locale }
  # end

  def present(object, klass = nil)
    klass ||= "#{object.class}Presenter".constantize
    klass.new(object, view_context)
  end

  def current_user
    @current_user ||= Account.find(session[:account_id]) if session[:account_id]
  end

  def log_out
    session.delete(:account_id)
    @current_user = nil
  end

  def show_fobbiden
    if request.xhr?
      render js: "window.location = '/403'"
    else
      render file: 'public/403.html', status: :forbidden, layout: false
    end
  end
end
