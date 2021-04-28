# frozen_string_literal: true

class CoursesController < ApplicationController
  def index
    if current_user.teacher?
      @courses = Course.filter(params.slice(:stadium)).by_teacher(current_user.users.first.id).order(:id)
                     .includes(:course_category, :teacher_courses, :teachers, :stadium, :student_courses)
                     .page(params[:page]).per(PAGE).decorate
    elsif current_user.teaching_management?
      stadium_ids = current_user.teaching_management_stadia.map(&:stadium_id)
      @courses = Course.filter(params.slice(:stadium)).by_stadiums(stadium_ids).order(:id)
                     .includes(:course_category, :teacher_courses, :teachers, :stadium, :student_courses)
                     .page(params[:page]).per(PAGE).decorate
    else
      @courses = Course.filter(params.slice(:stadium)).order(:id)
                     .includes(:course_category, :teacher_courses, :teachers, :stadium, :student_courses)
                     .page(params[:page]).per(PAGE).decorate
    end
    @stadia = Stadium.active.order(:id)
  end

  def show
    @course = Course.find(params[:id]).decorate
    authorize @course
    @students = Student.by_course(@course.id).includes(:student_courses).page(params[:page]).per(PAGE).decorate
  end

  def new
    authorize Course
    @form = CourseForm.build()
  end

  def create
    authorize Course
    @form = CourseForm.build(params)
    if @form.save
      redirect_to courses_path, notice: I18n.t('notices.save')
    else
      render :new
    end
  end

  def edit
    authorize Course
    @form = CourseForm.build(params)
  end

  def update
    authorize Course
    @form = CourseForm.build(params)
    if @form.save
      redirect_to courses_path, notice: I18n.t('notices.save')
    else
      render :edit
    end
  end

  def destroy
    authorize Course
    @course = Course.active.find(params[:id])
    @course.update!(deleted: true)
    redirect_to courses_path, notice: I18n.t('notices.delete')
  end
end
