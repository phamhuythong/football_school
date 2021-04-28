# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :get_user, except: %i[index show new create]

  def index
    @teachers = User.active.order(:id).page(params[:page]).per(PAGE)
  end

  def show; end

  def new
    @form = User.new
  end

  def create
    @form = User.new user_params
    if @form.save
      redirect_to users_path, notice: I18n.t('notices.save')
    else
      render :new
    end
  end

  def edit
    @form = User.active.find(params[:id])
  end

  def update
    @form = User.active.find(params[:id])
    if @form.update(user_params)
      redirect_to users_path, notice: I18n.t('notices.save')
    else
      render :edit
    end
  end

  def destroy
    @teacher.update!(deleted: true)
    redirect_to users_path, notice: I18n.t('notices.delete')
  end

  private

  def user_params
    params.require(:user).permit :id, :code, :first_name, :last_name, :middle_name, :gender, :date_of_birth,
                                 :phone, :type, :lock_version, :address, Address.address_params
  end

  def get_user
    @teacher = User.active.find(params[:id])
  end
end
