# frozen_string_literal: true

class Accounts::StadiumForm < BaseForm
  attribute :account_id

  attr_accessor :stadia, :stadium_ids, :args

  validates :account_id, presence: true

  def self.build(params = {})
    instance = new

    if params[:id]
      instance.record = Account.find(params[:id])
      return nil if instance.record.blank?
    end

    instance.assign_params(params)
    instance.load_association

    instance
  end

  def self.permitted_params(params)
    params.require(:accounts_stadium_form).permit :id, :account_id, stadium_ids: []
  end

  def assign_params(params)
    self.account_id = params[:id]
    self.attributes = Accounts::StadiumForm.permitted_params(params) if params[:accounts_stadium_form].present?
    self.args = params[:accounts_stadium_form]
  end

  def load_association
    load_collection
    assign_association
  end

  def load_collection
    self.stadia = Stadium.active.order(:id)
  end

  def assign_association
    assign_old_stadium
  end

  def assign_old_stadium
    if args&.dig(:stadium_ids).present?
      self.stadium_ids = args[:stadium_ids].reject { |c| c&.blank? }.map(&:to_i)
    elsif record.present?
      self.stadium_ids = record.teaching_management.stadium_ids
    end
  end

  def persist!
    ActiveRecord::Base.transaction do
      record.teaching_management.teaching_management_stadia.delete_all
      stadium_ids.each do |stadium_id|
        record.teaching_management.teaching_management_stadia.create!(stadium_id: stadium_id)
      end
    end
  end
end
