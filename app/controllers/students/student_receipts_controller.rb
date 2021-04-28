# frozen_string_literal: true

class Students::StudentReceiptsController < ApplicationController
  def index
    @student = Student.active.find(params[:student_id])
    @student_receipts = @student.student_receipts.active.includes(:course).page(params[:page]).per(PAGE)
  end

  def show
    @student = Student.active.find(params[:student_id])
    @student_receipt = StudentReceipt.includes(:course, :receipt_category).find(params[:id])
  end

  def new
    authorize StudentReceipt
    @form = Students::StudentReceiptForm.build(params)
  end

  def create
    authorize StudentReceipt
    @form = Students::StudentReceiptForm.build(params)
    if @form.save
      redirect_after_save(params)
    else
      render :new
    end
  end

  def edit
    authorize StudentReceipt
    @form = Students::StudentReceiptForm.build(params)
  end

  def update
    authorize StudentReceipt
    @form = Students::StudentReceiptForm.build(params)
    if @form.save
      redirect_after_save(params)
    else
      render :edit
    end
  end

  def destroy
    authorize StudentReceipt
    @student_course = StudentReceipt.find(params[:id])
    @student_course.update!(deleted: true)
    back_url = params[:course_id] ? course_path(params[:course_id]) : student_student_receipts_path(params[:student_id])
    redirect_to back_url, notice: I18n.t('notices.delete')
  end

  private

  def redirect_after_save(params)
    back_url = params[:course_id] ? course_path(params[:course_id]) : student_student_receipts_path(params[:student_id])
    redirect_to back_url, notice: I18n.t('notices.save')
  end
end
