# frozen_string_literal: true

class Students::StudentCoursesController < ApplicationController
  def index
    @student = Student.active.find(params[:student_id])
    @student_courses = @student.student_courses.active.includes(:course)
  end

  def show; end

  def new
    @form = Students::StudentCourseForm.build(params)
  end

  def create
    @form = Students::StudentCourseForm.build(params)
    if @form.save
      redirect_after_save(params)
    else
      render :new
    end
  end

  def edit
    @form = Students::StudentCourseForm.build(params)
  end

  def update
    @form = Students::StudentCourseForm.build(params)
    if @form.save
      redirect_after_save(params)
    else
      render :edit
    end
  end

  def destroy
    @student_course = StudentCourse.find(params[:id])
    @student_course.update!(deleted: true)
    back_url = params[:course_id] ? course_path(params[:course_id]) : students_path(params[:student_id])
    redirect_to back_url, notice: I18n.t('notices.delete')
  end

  private

  def redirect_after_save(params)
    redirect_to student_path(params[:student_id]), notice: I18n.t('notices.save')
  end
end
