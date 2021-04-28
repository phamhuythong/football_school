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

  def save
    if valid?
      ReceiptCategory.create!(attributes_for_active_record)
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
    params.require(:receipt_category_form).permit :id, :name, :price
  end
end
