# frozen_string_literal: true

class CoursesController < ApplicationController
  before_action :pundit_authorize, except: %i[show]

  def index
    if current_user.teacher?
      @courses = Course.filter(params.slice(:stadium)).by_teacher(current_user.user.id).order(:id)
                       .includes(:course_category, :teacher_courses, :teachers, :stadium, :student_courses)
                       .page(params[:page]).per(PAGE).decorate
    elsif current_user.teaching_management?
      stadium_ids = current_user.teaching_management.teaching_management_stadia.map(&:stadium_id)
      @courses = Course.filter(params.slice(:stadium)).by_stadiums(stadium_ids).order(:id)
                       .includes(:course_category, :teacher_courses, :teachers, :stadium, :student_courses)
                       .page(params[:page]).per(PAGE).decorate
    else
      @courses = Course.filter(params.slice(:stadium)).order(:id)
                       .includes(:course_category, :teacher_courses, :teachers, :stadium, :student_courses)
                       .page(params[:page]).per(PAGE).decorate
    end
    @stadia = policy_scope(Stadium)
  end

  def show
    @course = Course.find(params[:id]).decorate
    authorize @course
    @students = Student.by_course(@course.id).includes(:student_courses).page(params[:page]).per(PAGE).decorate
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
    if @form.save
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

  def pundit_authorize
    authorize Course
  end
end
