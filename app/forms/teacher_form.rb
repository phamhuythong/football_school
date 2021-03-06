# frozen_string_literal: true

class TeacherForm < BaseForm
  include ImageUploader[:avatar]
  attribute :code
  attribute :first_name
  attribute :last_name
  attribute :middle_name
  attribute :gender
  attribute :date_of_birth
  attribute :phone
  attribute :address
  attribute :lock_version
  attribute :avatar_data

  validates :first_name, presence: true
  validate :uploaded_avatar

  def self.build(params = {})
    instance = new

    if params[:id]
      instance.record = Teacher.find(params[:id])
      return nil if instance.record.blank?

      instance.restore_from_record
    end

    instance.attributes = permitted_params(params) if params[:teacher_form].present?

    instance
  end

  def save
    if valid?
      self.code = "DM-GV-#{rand(RANDOM_LIMIT).to_s.rjust(ZERO_RJUST, '0')}"
      Teacher.create!(attributes_for_record)
      true
    else
      false
    end
  end

  def update
    if valid?
      record.update!(attributes_for_record)
      true
    else
      false
    end
  end

  def self.permitted_params(params)
    params.require(:teacher_form).permit :id, :first_name, :last_name, :middle_name, :gender, :date_of_birth, :avatar,
                                         :phone, :address, :lock_version, Address.address_params, course_ids: []
  end

  def uploaded_avatar
    avatar_attacher.errors.each do |error|
      errors.add(:avatar, error)
    end
  end
end
