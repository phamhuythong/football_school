# frozen_string_literal: true

class AuthenticationsController < ApplicationController
  # skip_before_action :require_login

  # def create
  #   ActiveRecord::Base.transaction do
  #     user_info = User.from_omniauth(params)
  #     if user_info[:user].present?
  #       session[:user_id] = user_info[:user].id
  #       if user_info[:first_time]
  #         begin
  #           UserMailer.notify_new_user(user_info[:user]).deliver_now
  #         rescue StandardError => e
  #           # do something with the messages in exception object e
  #           flash[:error] = 'Problems sending email'
  #         end
  #       end
  #       if user_info[:user].email_notification_header.blank?
  #         user_info[:user].create_email_notification_header(createnotification: true)
  #         user_info[:user].email_notification_header.update_attribute(:unapprovenotification, true)
  #       end

  #       redirect_back_or root_url
  #     else
  #       redirect_to root_url, alert: I18n.t('controllers.sessions.invalide_g_suite_domain')
  #     end
  #   rescue StandardError => e
  #     p e
  #     raise ActiveRecord::Rollback
  #     redirect_to omniauth_failure_authentications_url
  #   rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError,
  #          Net::SMTPUnknownError => e
  #     redirect_back_or root_url
  #   end
  # end

  # def omniauth_failure
  #   redirect_to root_url, alert: I18n.t('controllers.sessions.invalide_g_suite_domain')
  # end
end
