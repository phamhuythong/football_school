# typed: strict
# frozen_string_literal: true

module ErrorHelper
  def error_notification_for(form)
    return if form.errors.full_messages.blank?

    tag.div(class: 'm_errorForm') do
      tag.ul do
        tag.li(I18n.t('errors.messages.notification'), class: 'error')
      end
    end
  end

  def error_class_for(form, column_name)
    return 'error' if raw_error_messages_for(form, column_name).present?
  end

  def error_messages_for(form, column_name)
    messages = raw_error_messages_for(form, column_name)
    safe_join(messages.map { |m| tag.p(m, class: 'error') })
  end

  private

  def raw_error_messages_for(form, column_name)
    form.object.errors.full_messages_for(column_name)
  end
end
