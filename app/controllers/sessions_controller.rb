# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :require_login
  skip_before_action :verify_authenticity_token

  def new
    redirect_to root_url if current_user
  end

  def create
    account = Account.find_by!(email: session_params[:email].downcase)
    if account&.authenticate(session_params[:password])
      log_in account
      redirect_to root_url
    else
      flash.now[:alert] = true
      render :new
    end
  end

  def destroy
    log_out
    redirect_to login_url
  end

  private

  def session_params
    params.require(:session).permit(:email, :username, :password)
  end
end
