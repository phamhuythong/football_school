# frozen_string_literal: true

class StadiumForm < BaseForm
  attribute :name
  attribute :stadium_group_id
  attribute :address

  attr_accessor :stadium_groups

  validates :name, presence: true
  validates :stadium_group_id, presence: true

  def self.build(params = {})
    instance = new

    if params[:id]
      instance.record = Stadium.find(params[:id])
      return nil if instance.record.blank?

      instance.restore_from_record
    end

    instance.attributes = permitted_params(params) if params[:stadium_form].present?
    instance.assign_associations if params[:stadium_form].blank?

    instance
  end

  def save
    if valid?
      Stadium.create!(attributes_for_record)
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
    params.require(:stadium_form).permit :id, :name, :stadium_group_id, :address
  end

  def assign_associations
    self.stadium_groups = StadiumGroup.active.order(:id)
  end
end
