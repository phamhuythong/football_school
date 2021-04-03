# frozen_string_literal: true

class CoursesController < ApplicationController
  def index
    @courses = Course.filter(params.slice(:stadium)).includes(:course_category, :teacher, :stadium,
                                                              :student_courses).page(params[:page]).per(PAGE)
    @stadia = Stadium.active.order(:id)
  end

  def show
    @course = Course.find(params[:id])
    @teacher = @course.teacher
    @students = Student.by_course(@course.id).includes(:student_courses).page(params[:page]).per(PAGE)
  end

  def new
    @form = CourseForm.build
  end

  def create
    @form = CourseForm.build(params)
    if @form.save
      redirect_to courses_path, notice: I18n.t('notices.save')
    else
      render :new
    end
  end

  def edit
    @form = CourseForm.build(params)
  end

  def update
    @form = CourseForm.build(params)
    if @form.update
      redirect_to courses_path, notice: I18n.t('notices.save')
    else
      render :edit
    end
  end

  def destroy
    @course = Course.active.find(params[:id])
    @course.update!(deleted: true)
    redirect_to courses_path, notice: I18n.t('notices.delete')
  end
end
