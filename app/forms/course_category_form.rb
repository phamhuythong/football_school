# frozen_string_literal: true

class CourseCategoryForm < BaseForm
  attribute :name
  attribute :info

  validates :name, presence: true

  def self.build(params = {})
    instance = new

    if params[:id]
      record = CourseCategory.find(params[:id])
      return nil if record.blank?

      instance.restore_from_record(record)
    end

    instance.attributes = permitted_params(params) if params[:course_category_form].present?

    instance
  end

  def save
    if valid?
      CourseCategory.create!(attributes_for_active_record)
      true
    else
      false
    end
  end

  def update
    if valid?
      record = CourseCategory.find(id)
      return false if record.blank?

      record.update!(attributes_for_active_record)
      true
    else
      false
    end
  end

  def self.permitted_params(params)
    params.require(:course_category_form).permit :id, :name, :info
  end
end
