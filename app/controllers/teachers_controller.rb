# frozen_string_literal: true

class TeachersController < ApplicationController
  before_action :pundit_authorize

  def index
    @teachers = Teacher.filter(params.slice(:first_name)).order(:id).page(params[:page]).per(PAGE).decorate
  end

  def show; end

  def new
    @form = TeacherForm.build
  end

  def create
    @form = TeacherForm.build(params)
    if @form.save
      redirect_to teachers_path, notice: I18n.t('notices.save')
    else
      render :new
    end
  end

  def edit
    @form = TeacherForm.build(params)
  end

  def update
    @form = TeacherForm.build(params)
    if @form.update
      redirect_to teachers_path, notice: I18n.t('notices.save')
    else
      render :edit
    end
  end

  def destroy
    @teacher = Teacher.active.find(params[:id])
    @teacher.update!(deleted: true)
    redirect_to teachers_path, notice: I18n.t('notices.delete')
  end

  def pundit_authorize
    authorize Teacher
  end
end
