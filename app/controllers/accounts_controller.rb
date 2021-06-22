# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :pundit_authorize, except: %i[assign_stadium process_assign_stadium]

  def index
    @accounts = Account.filter(params.slice(:email_username)).order(:id).page(params[:page]).per(PAGE).decorate
  end

  def show; end

  def new
    @form = AccountForm.build
  end

  def create
    @form = AccountForm.build(params)
    if @form.save
      redirect_to accounts_path, notice: I18n.t('notices.save')
    else
      render :new
    end
  end

  def edit
    @form = AccountForm.build(params)
  end

  def update
    @form = AccountForm.build(params)
    if @form.save
      redirect_to accounts_path, notice: I18n.t('notices.save')
    else
      render :edit
    end
  end

  def destroy
    @account = Account.active.find(params[:id])
    @account.user&.delete
    @account.delete
    redirect_to accounts_path, notice: I18n.t('notices.delete')
  end

  def assign_stadium
    @account = Account.active.find(params[:id])
    authorize @account
    @form = Accounts::StadiumForm.build(params)
  end

  def process_assign_stadium
    @account = Account.active.find(params[:id])
    authorize @account
    @form = Accounts::StadiumForm.build(params)
    if @form.save
      redirect_to accounts_path, notice: I18n.t('notices.save')
    else
      render :assign_stadium
    end
  end

  def pundit_authorize
    authorize Account
  end
end
