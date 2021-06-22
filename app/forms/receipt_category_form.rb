# frozen_string_literal: true

class ReceiptCategoryForm < BaseForm
  attribute :name
  attribute :price

  validates :name, presence: true
  validates :price, presence: true

  def self.build(params = {})
    instance = new

    if params[:id]
      instance.record = ReceiptCategory.find(params[:id])
      return nil if instance.record.blank?

      instance.restore_from_record
    end

    instance.attributes = permitted_params(params) if params[:receipt_category_form].present?

    instance
  end

  def self.permitted_params(params)
    params.require(:receipt_category_form).permit :id, :name, :price
  end

  def persist!
    ActiveRecord::Base.transaction do
      self.price = price.to_s.gsub(/[$,]/, '').to_f
      self.record = create! unless exist?
      update! if exist?
    end
  end

  def create!
    ReceiptCategory.create!(attributes_for_record)
  end

  def update!
    record.update!(attributes_for_record)
  end
end
