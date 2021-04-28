# frozen_string_literal: true

module ApplicationHelper
  def present(object, klass = nil)
    klass ||= "#{object.class}Presenter".constantize
    presenter = klass.new(object, self)
    yield presenter if block_given?
    presenter
  end

  def format_date(date)
    return '' unless date

    date.strftime('%d-%m-%Y')
  end

  def format_money(money)
    return '' unless money

    number_with_precision(money, precision: 0, delimiter: ',', separator: '.')
  end

  def admin_controller?
    %w[stadium_groups stadia course_categories teachers receipt_categories].include? params[:controller]
  end
end
