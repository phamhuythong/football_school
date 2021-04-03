# frozen_string_literal: true

class CourseForm < BaseForm
  attribute :name
  attribute :stadium_id
  attribute :teacher_id
  attribute :course_category_id
  attribute :start_time
  attribute :end_time
  attribute :start_date
  attribute :end_date
  attribute :lock_version

  attr_accessor :stadia, :teachers, :course_categories

  validates :name, presence: true
  validates :stadium_id, presence: true
  validates :teacher_id, presence: true
  validates :course_category_id, presence: true

  def self.build(params = {})
    instance = new

    if params[:id]
      record = Course.find(params[:id])
      return nil if record.blank?

      instance.restore_from_record(record)
    end

    instance.attributes = permitted_params(params) if params[:course_form].present?
    instance.assign_associations if params[:course_form].blank?

    instance
  end

  def save
    if valid?
      Course.create!(attributes_for_active_record)
      true
    else
      false
    end
  end

  def update
    if valid?
      record = Course.find(id)
      return false if record.blank?

      record.update!(attributes_for_active_record)
      true
    else
      false
    end
  end

  def self.permitted_params(params)
    params.require(:course_form).permit :id, :name, :stadium_id, :teacher_id, :course_category_id,
                                        :start_time, :end_time, :start_date, :end_date, :lock_version
  end

  def assign_associations
    self.stadia = Stadium.active.order(:id)
    self.teachers = Teacher.active.order(:id)
    self.course_categories = CourseCategory.active.order(:id)
  end
end
