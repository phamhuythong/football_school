# frozen_string_literal: true

class StudentsController < ApplicationController
  before_action :pundit_authorize
  before_action :merge_current_user, only: [:new, :create, :edit, :update]

  def index
    @students = Student.filter(params.slice(:course,
                                            :first_name)).with_attached_avatar.order(:id).page(params[:page]).per(PAGE).decorate
    @courses = Course.active.order(:id)
  end

  def show
    @student = Student.active.find(params[:id])
    @student_courses = @student.student_courses.active.includes(:course)
  end

  def new
    @form = StudentForm.build(params)
  end

  def create
    @form = StudentForm.build(params)
    if @form.save
      redirect_after_save(params)
    else
      render :new
    end
  end

  def edit
    @form = StudentForm.build(params)
  end

  def update
    @form = StudentForm.build(params)
    if @form.save
      redirect_after_save(params)
    else
      render :edit
    end
  end

  def destroy
    @student = Student.active.find(params[:id])
    @student.update!(deleted: true)
    redirect_to students_path, notice: I18n.t('notices.delete')
  end

  private

  def redirect_after_save(params)
    back_url = params[:course_id] ? course_path(params[:course_id]) : students_path
    redirect_to back_url, notice: I18n.t('notices.save')
  end

  def pundit_authorize
    authorize Student
  end

  def merge_current_user
    params.merge!(current_user: current_user)
  end
end
