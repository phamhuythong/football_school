# frozen_string_literal: true

class Courses::LessonsController < ApplicationController
  def index
    @lessons = Lesson.by_course(params[:course_id]).page(params[:page]).per(PAGE)
  end

  def show; end

  def new
    @form = Courses::LessonForm.build(params)
  end

  def create
    @form = Courses::LessonForm.build(params)
    if @form.save
      redirect_after_save(params)
    else
      render :new
    end
  end

  def edit
    @form = Courses::LessonForm.build(params)
  end

  def update
    @form = Courses::LessonForm.build(params)
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
    redirect_to course_lessons_path(params[:course_id]), notice: I18n.t('notices.save')
  end
end
