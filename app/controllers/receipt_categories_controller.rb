# frozen_string_literal: true

class ReceiptCategoriesController < ApplicationController
  before_action :pundit_authorize

  def index
    @receipt_categories = ReceiptCategory.active.order(:id).page(params[:page]).per(PAGE)
  end

  def show; end

  def new
    @form = ReceiptCategoryForm.build
  end

  def create
    @form = ReceiptCategoryForm.build(params)
    if @form.save
      redirect_to receipt_categories_path, notice: I18n.t('notices.save')
    else
      render :new
    end
  end

  def edit
    @form = ReceiptCategoryForm.build(params)
  end

  def update
    @form = ReceiptCategoryForm.build(params)
    if @form.save
      redirect_to receipt_categories_path, notice: I18n.t('notices.save')
    else
      render :edit
    end
  end

  def destroy
    @receipt_category = ReceiptCategory.active.find(params[:id])
    @receipt_category.update!(deleted: true)
    redirect_to receipt_categories_path, notice: I18n.t('notices.delete')
  end

  def pundit_authorize
    authorize ReceiptCategory
  end
end
