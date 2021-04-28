# frozen_string_literal: true

class PaginatingDecorator < Draper::CollectionDecorator
  # support for will_paginate
  # delegate :current_page, :total_entries, :total_pages, :per_page, :offset

  # support for kaminari
  delegate :current_page, :total_pages, :limit_value, :entry_name, :total_count, :offset_value, :last_page?
end
