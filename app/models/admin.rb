# frozen_string_literal: true

class Admin < User
  resourcify

  include Scopeable
end
