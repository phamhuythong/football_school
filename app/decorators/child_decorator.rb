# frozen_string_literal: true

class ChildDecorator < BaseDecorator
  def initialize(child)
    @child = child
    super
  end
end
