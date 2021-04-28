# frozen_string_literal: true

module Scopeable
  extend ActiveSupport::Concern

  def self.included(klass)
    klass.instance_eval do
      scope :active, -> { where(deleted: false) }
    end
  end
end
