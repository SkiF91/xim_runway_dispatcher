require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module XimApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    config.encoding = "utf-8"

    config.action_cable.mount_path = '/dispatcher'

    config.i18n.default_locale = :ru
    I18n.enforce_available_locales = true

    config.session_store :cookie_store,
                         :key => '_xim_session',
                         :path => config.relative_url_root || '/'

  end
end
