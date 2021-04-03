# frozen_string_literal: true

module ApplicationHelper
  def present(object, klass = nil)
    klass ||= "#{object.class}Presenter".constantize
    presenter = klass.new(object, self)
    yield presenter if block_given?
    presenter
  end

  def date_format(date)
    return '' unless date

    date.strftime('%d-%m-%Y')
  end
end
