# frozen_string_literal: true

module ApplicationHelper
  $breakpoint = 'col-md'
  $breakpoint_4 = 'col-md-4'
  $breakpoint_3 = 'col-md-3'
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

    number_with_precision(money, precision: 2, delimiter: ',', separator: '.')
  end

  def admin_controller?
    %w[stadium_groups stadia course_categories teachers receipt_categories].include? params[:controller]
  end

  def display_form_avatar(obj)
    obj&.avatar_url.present? ? obj.avatar_url : 'default_avatar.png'
  end
end
