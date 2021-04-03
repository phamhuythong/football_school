# frozen_string_literal: true

class Students::StudentCourseForm < BaseForm
  attribute :student_id
  attribute :course_id
  attribute :register_date
  attribute :start_date

  attr_accessor :course_name, :courses, :args

  validates :course_id, presence: true, unless: :exist?
  validates :register_date, presence: true
  validates :start_date, presence: true

  def self.build(params = {})
    instance = new

    if params[:id]
      record = StudentCourse.find(params[:id])
      return nil if record.blank?

      instance.restore_from_record(record)
    end

    instance.attributes = permitted_params(params) if params[:students_student_course_form].present?
    instance.args = params
    instance.load_associations(record)

    instance
  end

  def load_associations(record)
    if exist?
      self.course_name = record.course.name
    else
      course_ids = Student.find(args[:student_id]).student_courses.map(&:course_id)
      self.courses = Course.active.where.not(id: course_ids).order(:id)
    end
  end

  def persist!
    ActiveRecord::Base.transaction do
      create! unless exist?
      update! if exist?
    end
  end

  def create!
    Student.find(args[:student_id]).student_courses.create!(attributes_for_active_record)
  end

  def update!
    record = StudentCourse.find(id)
    record.update!(attributes_for_active_record)
  end

  def self.permitted_params(params)
    params.require(:students_student_course_form).permit :id, :student_id, :course_id, :register_date, :start_date, :lock_version
  end
end
