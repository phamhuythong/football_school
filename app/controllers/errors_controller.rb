# frozen_string_literal: true

class ErrorsController < ApplicationController
  def file_not_found
    render file: Rails.public_path.join('404.html'), status: :not_found, layout: false
  end

  def unprocessable
    render file: Rails.public_path.join('422.html'), status: :unprocessable, layout: false
  end

  def internal_server_error
    render file: Rails.public_path.join('500.html'), status: :internal_server_error, layout: false
  end

  def route_not_found
    render file: Rails.public_path.join('404.html'), status: :not_found, layout: false
  end
end
