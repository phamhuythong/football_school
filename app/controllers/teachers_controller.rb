# frozen_string_literal: true

class TeachersController < ApplicationController
  def index
    @teachers = Teacher.active.order(:id).page(params[:page]).per(PAGE)
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
      Rails.logger.info @form.errors.inspect
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
end
