require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module FootballSchool
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.time_zone = 'Hanoi'

    # config.paths['config/routes.rb'] = %w[
    #   config/routes/admin.rb
    #   config/routes/sites.rb
    # ].map { |relative_path| Rails.root.join(relative_path) }

    config.paths.add 'lib', eager_load: true

    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
    config.i18n.available_locales = [:vi, :en]
    config.i18n.default_locale = :vi

    config.active_model.i18n_customize_full_message = true

    config.action_view.field_error_proc = Proc.new { |html_tag, instance| html_tag }

    # for sanitize: common tags and attributes
    config.action_view.sanitized_allowed_tags = %w(body pre address div p span caption
      h1 h2 h3 h4 h5 h6 em strong b i big small u s a li ol ul marquee center
      font br img link hr meta table tbody thead tr th td dl dt dd form input option
      blockquote sub sup del ins cite q var samp code tt kbd dfn)
    config.action_view.sanitized_allowed_attributes = %w(href src width height alt cite datetime title class name lang
      abbr style border align scope cellpadding cellspacing summary)
  end
end
