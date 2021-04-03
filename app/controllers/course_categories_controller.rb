# frozen_string_literal: true

class CourseCategoriesController < ApplicationController
  def index
    @course_categories = CourseCategory.active.order(:id).page(params[:page]).per(PAGE)
  end

  def show; end

  def new
    @form = CourseCategoryForm.build
  end

  def create
    @form = CourseCategoryForm.build(params)
    if @form.save
      redirect_to course_categories_path, notice: I18n.t('notices.save')
    else
      render :new
    end
  end

  def edit
    @form = CourseCategoryForm.build(params)
  end

  def update
    @form = CourseCategoryForm.build(params)
    if @form.update
      redirect_to course_categories_path, notice: I18n.t('notices.save')
    else
      render :edit
    end
  end

  def destroy
    @course_category = CourseCategory.active.find(params[:id])
    @course_category.update!(deleted: true)
    redirect_to course_categories_path, notice: I18n.t('notices.delete')
  end
end
