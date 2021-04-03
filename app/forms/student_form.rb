# frozen_string_literal: true

class StudentForm < BaseForm
  attribute :code
  attribute :first_name
  attribute :last_name
  attribute :middle_name
  attribute :gender
  attribute :date_of_birth
  attribute :phone
  attribute :address
  attribute :mother_name
  attribute :mother_phone
  attribute :father_name
  attribute :father_phone
  attribute :lock_version

  attr_accessor :courses, :course_ids, :args, :student_courses, :course_id, :register_date, :start_date

  validates :first_name, presence: true
  validates :course_id, presence: true, unless: :exist?
  validates :register_date, presence: true, unless: :exist?
  validates :start_date, presence: true, unless: :exist?

  def self.build(params = {})
    instance = new

    if params[:id]
      record = Student.find(params[:id])
      return nil if record.blank?

      instance.restore_from_record(record)
    end

    instance.attributes = permitted_params(params) if params[:student_form].present?
    # instance.args = params[:student_form]
    instance.args = params
    instance.load_association(record)

    instance
  end

  def self.permitted_params(params)
    params.require(:student_form).permit :id, :first_name, :last_name, :middle_name, :gender, :date_of_birth,
                                         :phone, :address, :mother_name, :mother_phone, :father_name, :father_phone,
                                         :course_id, :register_date, :start_date,
                                         :lock_version, Address.address_params, course_ids: []
  end

  def load_association(record)
    load_collection
    assign_association(record)
  end

  def load_collection
    self.courses = Course.active.order(:id)
  end

  def assign_association(_record)
    self.course_id = args[:course_id].to_i if args[:course_id].present?
    # if args&.dig(:course_ids).present?
    #   self.course_ids = args[:course_ids].reject { |c| c&.blank? }.map(&:to_i)
    # elsif record.present?
    #   self.course_ids = record.student_courses.active.map(&:course_id)
    # end
  end

  def persist!
    ActiveRecord::Base.transaction do
      record = create! unless exist?
      record = update! if exist?
      save_association(record)
    end
  end

  def create!
    self.code = "DM-HV-#{rand(RANDOM_LIMIT).to_s.rjust(ZERO_RJUST, '0')}"
    Student.create!(attributes_for_active_record)
  end

  def update!
    record = Student.find(id)
    record.update!(attributes_for_active_record)
    record
  end

  def save_association(record)
    create_course!(record) unless exist?
    # create_courses!(record, course_ids) and return if id.blank?

    # update_courses!(record)
  end

  def create_course!(record)
    record.student_courses.create!(course_id: course_id, register_date: register_date, start_date: start_date)
  end

  def create_courses!(record, ids)
    ids.each do |id|
      record.student_courses.find_or_create_by!(course_id: id).update!(deleted: false)
    end
  end

  def update_courses!(record)
    new_course_ids = args[:course_ids].reject { |c| c&.blank? }.map(&:to_i)
    old_course_ids = record.student_courses.active.map(&:course_id)
    adding_course_ids = new_course_ids - old_course_ids
    elimination_course_ids = old_course_ids - new_course_ids
    create_courses!(record, adding_course_ids)
    # rubocop: disable Rails/SkipsModelValidations
    record.student_courses.where(course_id: elimination_course_ids).update_all(deleted: true)
    # rubocop: enable Rails/SkipsModelValidations
  end

  def student_courses_attributes=(student_courses_params)
    @student_courses ||= []
    student_courses_params.each do |_i, student_course_param|
      @student_courses.push(SocialCourseForm.new(student_course_param))
    end
  end
end
