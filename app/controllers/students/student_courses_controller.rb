# frozen_string_literal: true

class Students::StudentCoursesController < ApplicationController
  before_action :merge_current_user, only: %i[new create edit update]

  def index
    @student = Student.active.find(params[:student_id])
    @student_courses = @student.student_courses.active.includes(:course).order(:id).page(params[:page]).per(PAGE)
  end

  def show; end

  def new
    authorize StudentCourse
    @form = Students::StudentCourseForm.build(params)
  end

  def create
    authorize StudentCourse
    @form = Students::StudentCourseForm.build(params)
    if @form.save
      redirect_after_save(params)
    else
      render :new
    end
  end

  def edit
    @student_course = StudentCourse.find(params[:id])
    authorize @student_course
    @form = Students::StudentCourseForm.build(params)
  end

  def update
    @student_course = StudentCourse.find(params[:id])
    authorize @student_course
    @form = Students::StudentCourseForm.build(params)
    if @form.save
      redirect_after_save(params)
    else
      render :edit
    end
  end

  def destroy
    @student_course = StudentCourse.find(params[:id])
    authorize @student_course
    @student_course.update!(deleted: true)
    back_url = params[:course_id] ? course_path(params[:course_id]) : student_student_courses_path(params[:student_id])
    redirect_to back_url, notice: I18n.t('notices.delete')
  end

  private

  def redirect_after_save(params)
    back_url = params[:course_id] ? course_path(params[:course_id]) : student_student_courses_path(params[:student_id])
    redirect_to back_url, notice: I18n.t('notices.save')
  end

  def merge_current_user
    params.merge!(current_user: current_user)
  end
end
