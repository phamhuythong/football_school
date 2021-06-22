# frozen_string_literal: true

class StudentForm < BaseForm
  include ImageUploader[:avatar]
  include Pundit
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
  attribute :avatar
  attribute :email
  attribute :avatar_data

  attr_accessor :courses, :course_ids, :args, :student_courses, :course_id, :register_date, :start_date

  validates :first_name, presence: true
  validates :course_id, presence: true, unless: :exist?
  validates :register_date, presence: true, unless: :exist?
  validates :start_date, presence: true, unless: :exist?
  validate :uploaded_avatar
  # validate :valid_course_id, unless: :exist?

  def self.build(params = {})
    instance = new

    if params[:id]
      instance.record = Student.find(params[:id])
      return nil if instance.record.blank?

      instance.restore_from_record
    end

    instance.attributes = permitted_params(params) if params[:student_form].present?
    # instance.args = params[:student_form]
    instance.args = params
    instance.load_association

    instance
  end

  def self.permitted_params(params)
    params.require(:student_form).permit :id, :first_name, :last_name, :middle_name, :gender, :date_of_birth,
                                         :phone, :address, :mother_name, :mother_phone, :father_name, :father_phone,
                                         :course_id, :register_date, :start_date, :avatar, :email, :avatar,
                                         :lock_version, Address.address_params, course_ids: []
  end

  def load_association
    load_collection
    assign_association
  end

  def load_collection
    # self.courses = Course.active.order(:id)
    self.courses = CoursePolicy::Scope.new(args[:current_user], Course).resolve
  end

  def assign_association
    self.course_id = args[:course_id].to_i if args[:course_id].present?
    # if args&.dig(:course_ids).present?
    #   self.course_ids = args[:course_ids].reject { |c| c&.blank? }.map(&:to_i)
    # elsif record.present?
    #   self.course_ids = record.student_courses.active.map(&:course_id)
    # end
  end

  def persist!
    ActiveRecord::Base.transaction do
      create! unless exist?
      update! if exist?
      save_association
    end
  end

  def create!
    self.code = "DM-HV-#{rand(RANDOM_LIMIT).to_s.rjust(ZERO_RJUST, '0')}"
    self.record = Student.create!(attributes_for_record)
    record.avatar.attach(args[:student_form][:avatar]) if args[:student_form][:avatar].present?
  end

  def update!
    record.update!(attributes_for_record)
    record.avatar.attach(args[:student_form][:avatar]) if args[:student_form][:avatar].present?
  end

  def save_association
    create_course! unless exist?
    # create_courses!(record, course_ids) and return if id.blank?

    # update_courses!(record)
  end

  def create_course!
    record.student_courses.create!(course_id: course_id, register_date: register_date, start_date: start_date)
  end

  def uploaded_avatar
    avatar_attacher.errors.each do |error|
      errors.add(:avatar, error)
    end
  end

  def valid_course_id
    return true if args[:current_user].admin?

    stadium_ids = args[:current_user].teaching_management_stadia.active.map(&:stadium_id)
    course = Course.find(course_id)
    stadium_ids.include? course.stadium_id
  end

  # def create_courses!(ids)
  #   ids.each do |id|
  #     record.student_courses.find_or_create_by!(course_id: id).update!(deleted: false)
  #   end
  # end

  # def update_courses!
  #   new_course_ids = args[:course_ids].reject { |c| c&.blank? }.map(&:to_i)
  #   old_course_ids = record.student_courses.active.map(&:course_id)
  #   adding_course_ids = new_course_ids - old_course_ids
  #   elimination_course_ids = old_course_ids - new_course_ids
  #   create_courses!(adding_course_ids)
  #   record.student_courses.where(course_id: elimination_course_ids).update_all(deleted: true)
  # end

  # def student_courses_attributes=(student_courses_params)
  #   @student_courses ||= []
  #   student_courses_params.each do |_i, student_course_param|
  #     @student_courses.push(SocialCourseForm.new(student_course_param))
  #   end
  # end
end
