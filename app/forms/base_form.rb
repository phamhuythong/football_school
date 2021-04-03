# frozen_string_literal: true

class BaseForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :id

  RANDOM_LIMIT = 999_999
  ZERO_RJUST = 6

  def restore_from_record
    assign_attributes(record.attributes.slice(*attribute_names))
  end

  def attributes_for_active_record
    attributes.each_with_object({}) do |(key, _attr), hash|
      raise(NotImplementedError, "must implement #{self.class}##{key}") unless respond_to?(key)

      hash[key] = public_send(key)
    end
  end

  def save
    if valid?
      persist!
      true
    else
      Rails.logger.info errors.inspect
      false
    end
  end

  def persist!; end

  def exist?
    id.present?
  end
end
