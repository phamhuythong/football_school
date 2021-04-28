# frozen_string_literal: true

class CourseForm < BaseForm
  attribute :name
  attribute :stadium_id
  attribute :course_category_id
  attribute :start_time
  attribute :end_time
  attribute :start_date
  attribute :end_date
  attribute :lock_version

  attr_accessor :stadia, :teacher_ids, :teachers, :course_categories, :old_teacher_ids, :args

  validates :name, presence: true
  validates :stadium_id, presence: true
  # validates :teacher_ids, presence: true
  validates :course_category_id, presence: true

  def self.build(params = {})
    instance = new

    if params[:id]
      instance.record = Course.find(params[:id])
      return nil if instance.record.blank?

      instance.restore_from_record
    end

    instance.attributes = permitted_params(params) if params[:course_form].present?
    instance.assign_params(params)
    instance.load_association

    instance
  end

  def self.permitted_params(params)
    params.require(:course_form).permit :id, :name, :stadium_id, :course_category_id,
                                        :start_time, :end_time, :start_date, :end_date, :lock_version, teacher_ids: []
  end

  def assign_params(params)
    self.args = params[:course_form]
  end

  def load_association
    load_collection
    assign_association
  end

  def load_collection
    self.stadia = Stadium.active.order(:id)
    self.teachers = Teacher.active.order(:id)
    self.course_categories = CourseCategory.active.order(:id)
  end

  def assign_association
    assign_teacher
  end

  def assign_teacher
    if args&.dig(:teacher_ids).present?
      self.teacher_ids = args[:teacher_ids].reject { |c| c&.blank? }.map(&:to_i)
    elsif record.present?
      self.teacher_ids = record.teacher_courses.active.map(&:teacher_id)
    end
  end

  def persist!
    ActiveRecord::Base.transaction do
      self.record = create! unless exist?
      update! if exist?
      save_association
    end
  end

  def create!
    Course.create!(attributes_for_active_record)
  end

  def update!
    record.update!(attributes_for_active_record)
  end

  def save_association
    create_teacher_courses! unless exist?
    update_teacher_courses! if exist?
  end

  def create_teacher_courses!
    teacher_ids.each do |tid|
      record.teacher_courses.find_or_create_by!(teacher_id: tid).update!(deleted: false)
    end
  end

  def update_teacher_courses!
    self.old_teacher_ids = record.teacher_ids
    elimination_teacher_ids = old_teacher_ids - teacher_ids
    record.teacher_courses.where(teacher_id: elimination_teacher_ids).each do |tc|
      tc.update!(deleted: true)
    end
    create_teacher_courses!
  end
end
