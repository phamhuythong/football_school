# frozen_string_literal: true

class StadiumGroupForm < BaseForm
  attribute :name
  attribute :info

  attr_accessor :record

  validates :name, presence: true

  def self.build(params = {})
    instance = new

    if params[:id]
      instance.record = StadiumGroup.find(params[:id])
      return nil if instance.record.blank?

      instance.restore_from_record
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
