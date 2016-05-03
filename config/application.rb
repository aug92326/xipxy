require File.expand_path('../boot', __FILE__)

require 'rails/all'
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Xipsy
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
    config.active_record.schema_format = :sql


    config.autoload_paths += %W(#{config.root}/lib)
    config.to_prepare do
      require 'devise_registration_overrides'
      Devise::RegistrationsController.send(:include, DeviseRegistrationOverrides)
    end
  end
end

module ActsAsApi
  module Base
    module InstanceMethods
      def absolute_url(path)
        unless path =~ /\A(http(s?)|\/\/)/
          return "#{ Rails.application.config.asset_host }#{ path }"
        end
        path
      end
    end
  end
end

# The standard ruby Array class is extended by one instance method.
# compact the result so it doesnt show nil element from acts_as_api
class Array
  def as_api_response(api_template, options = {})

    collect do |item|
      if item.respond_to?(:as_api_response)
        item.as_api_response(api_template, options)
      else
        item
      end
    end.compact

  end

  def uniq_sorting
    collect.to_a.uniq.reject { |c| c.blank? }.sort_by {|word| word.downcase}
  end
end

require 'record_search'
