# frozen_string_literal: true

class StadiaController < ApplicationController
  def index
    @stadia = Stadium.active.order(:id).page(params[:page]).per(PAGE).includes(:stadium_group)
  end

  def show; end

  def new
    @form = StadiumForm.build
  end

  def create
    @form = StadiumForm.build(params)
    if @form.save
      redirect_to stadia_path, notice: I18n.t('notices.save')
    else
      render :new
    end
  end

  def edit
    @form = StadiumForm.build(params)
  end

  def update
    @form = StadiumForm.build(params)
    if @form.update
      redirect_to stadia_path, notice: I18n.t('notices.save')
    else
      render :edit
    end
  end

  def destroy
    @stadium = Stadium.find(params[:id])
    @stadium.update!(deleted: true)
    redirect_to stadia_path, notice: I18n.t('notices.delete')
  end
end
