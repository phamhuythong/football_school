# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :pundit_authorize

  def index
    @accounts = Account.active.order(:id).page(params[:page]).per(PAGE).decorate
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
    if @form.update
      redirect_to accounts_path, notice: I18n.t('notices.save')
    else
      render :edit
    end
  end

  def destroy
    @account = Account.active.find(params[:id])
    @account.update!(deleted: true)
    redirect_to accounts_path, notice: I18n.t('notices.delete')
  end

  def pundit_authorize
    authorize Account
  end
end
