# frozen_string_literal: true

module FormFieldHelper
  def hidden(form:, field:, **options)
    render 'shared/forms/hidden', options.merge(f: form, field: field)
  end

  def text(form:, field:, **options)
    render 'shared/forms/text', options.merge(f: form, field: field)
  end

  def dropdown(form:, field:, collection:, **options)
    render 'shared/forms/dropdown', options.merge(f: form, field: field, collection: collection)
  end

  def date(form:, field:, **options)
    render 'shared/forms/date', options.merge(f: form, field: field)
  end

  def time(form:, field:, **options)
    render 'shared/forms/time', options.merge(f: form, field: field)
  end

  def number(form:, field:, **options)
    render 'shared/forms/number', options.merge(f: form, field: field)
  end

  def email(form:, field:, **options)
    render 'shared/forms/email', options.merge(f: form, field: field)
  end

  def money(form:, field:, **options)
    render 'shared/forms/money', options.merge(f: form, field: field)
  end

  def file(form:, field:, **options)
    render 'shared/forms/file', options.merge(f: form, field: field)
  end

  def collection_checkboxes(form:, field:, collection:, **options)
    render 'shared/forms/collection_checkboxes', options.merge(f: form, field: field, collection: collection)
  end

  def collection_radios(form:, field:, collection:, **options)
    render 'shared/forms/collection_radios', options.merge(f: form, field: field, collection: collection)
  end

  def submit(form:, back_url:, **options)
    render 'shared/forms/submit', options.merge(f: form, back_url: back_url)
  end

  def modification_buttons(urls:, **options)
    render 'shared/modification_buttons', options.merge(urls)
  end

  def index_header(header:, new_url:, **options)
    render 'shared/index_header', options.merge(header: header, new_url: new_url)
  end

  def index_pagination(data:)
    render 'shared/index_pagination', data: data
  end
end
