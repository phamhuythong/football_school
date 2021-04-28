# frozen_string_literal: true

class StadiumGroupsController < ApplicationController
  before_action :pundit_authorize

  def index
    @stadium_groups = StadiumGroup.active.order(:id).page(params[:page]).per(PAGE)
  end

  def show; end

  def new
    @form = StadiumGroupForm.build
  end

  def create
    @form = StadiumGroupForm.build(params)
    if @form.save
      redirect_to stadium_groups_path, notice: I18n.t('notices.save')
    else
      render :new
    end
  end

  def edit
    @form = StadiumGroupForm.build(params)
  end

  def update
    @form = StadiumGroupForm.build(params)
    if @form.update
      redirect_to stadium_groups_path, notice: I18n.t('notices.save')
    else
      render :edit
    end
  end

  def destroy
    @stadium_group = StadiumGroup.active.find(params[:id])
    @stadium_group.update!(deleted: true)
    redirect_to stadium_groups_path, notice: I18n.t('notices.delete')
  end

  def pundit_authorize
    authorize StadiumGroup
  end
end
