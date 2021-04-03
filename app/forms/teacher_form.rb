# frozen_string_literal: true

class TeacherForm < BaseForm
  attribute :code
  attribute :first_name
  attribute :last_name
  attribute :middle_name
  attribute :gender
  attribute :date_of_birth
  attribute :phone
  attribute :address
  attribute :lock_version

  validates :first_name, presence: true

  def self.build(params = {})
    instance = new

    if params[:id]
      record = Teacher.find(params[:id])
      return nil if record.blank?

      instance.restore_from_record(record)
    end

    instance.attributes = permitted_params(params) if params[:teacher_form].present?

    instance
  end

  def save
    if valid?
      self.code = "DM-GV-#{rand(RANDOM_LIMIT).to_s.rjust(ZERO_RJUST, '0')}"
      Teacher.create!(attributes_for_active_record)
      true
    else
      false
    end
  end

  def update
    if valid?
      record = Teacher.find(id)
      return false if record.blank?

      record.update!(attributes_for_active_record)
      true
    else
      false
    end
  end

  def self.permitted_params(params)
    params.require(:teacher_form).permit :id, :first_name, :last_name, :middle_name, :gender, :date_of_birth,
                                         :phone, :address, :lock_version, Address.address_params, course_ids: []
  end
end
