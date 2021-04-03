# frozen_string_literal: true

class StadiumGroupForm < BaseForm
  attribute :name
  attribute :info

  validates :name, presence: true

  def self.build(params = {})
    instance = new

    if params[:id]
      record = StadiumGroup.find(params[:id])
      return nil if record.blank?

      instance.restore_from_record(record)
    end

    instance.attributes = permitted_params(params) if params[:stadium_group_form].present?

    instance
  end

  def save
    if valid?
      StadiumGroup.create!(attributes_for_active_record)
      true
    else
      false
    end
  end

  def update
    if valid?
      record = StadiumGroup.find(id)
      return false if record.blank?

      record.update!(attributes_for_active_record)
      true
    else
      false
    end
  end

  def self.permitted_params(params)
    params.require(:stadium_group_form).permit :id, :name, :info
  end
end
