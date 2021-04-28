# frozen_string_literal: true

class Students::StudentReceiptForm < BaseForm
  attribute :receipt_date
  attribute :receipt_no
  attribute :book_no
  attribute :student_id
  attribute :course_id
  attribute :receipt_category_id
  attribute :amount
  attribute :paid
  attribute :remain
  attribute :payer
  attribute :cashier
  attribute :prepared_by
  attribute :reason
  attribute :total_lessons
  attribute :lock_version

  attr_accessor :student, :courses, :receipt_categories, :preparer, :args

  validates :receipt_date, presence: true
  validates :receipt_no, presence: true
  validates :course_id, presence: true
  validates :receipt_category_id, presence: true
  validates :reason, presence: true
  validates :amount, presence: true
  validates :paid, presence: true
  validates :remain, presence: true
  validates :payer, presence: true
  validates :prepared_by, presence: true
  validates :total_lessons, presence: true

  def self.build(params = {})
    instance = new

    if params[:id]
      instance.record = StudentReceipt.find(params[:id])
      return nil if instance.record.blank?

      instance.restore_from_record
    end

    instance.assign_params(params)
    instance.load_association

    instance
  end

  def self.permitted_params(params)
    params.require(:students_student_receipt_form).permit :id, :receipt_date, :receipt_no, :book_no, :student_id, :course_id,
                                                          :receipt_category_id, :amount, :paid, :remain, :payer, :cashier,
                                                          :prepared_by, :reason, :total_lessons, :lock_version
  end

  def assign_params(params)
    self.student_id = params[:student_id]
    self.attributes = Students::StudentReceiptForm.permitted_params(params) if params[:students_student_receipt_form].present?
    self.args = params[:students_student_receipt_form]
  end

  def load_association
    load_collection
  end

  def load_collection
    self.courses = Course.by_student(student_id)
    self.receipt_categories = ReceiptCategory.active
  end

  def persist!
    ActiveRecord::Base.transaction do
      self.record = create! unless exist?
      update! if exist?
      update_course!
    end
  end

  def create!
    Student.find(student_id).student_receipts.create!(attributes_for_active_record)
  end

  def update!
    record.update!(attributes_for_active_record)
  end

  def update_course!
    student_course = StudentCourse.active.where(student_id: student_id, course_id: course_id).first
    return unless student_course

    student_course_total_lessons = StudentReceipt.by_student_course(student_id, course_id).sum(:total_lessons)
    student_course.update!(total_lessons: student_course_total_lessons)
  end
end
