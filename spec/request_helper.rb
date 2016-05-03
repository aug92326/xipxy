require 'spec_helper'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'capybara-screenshot/rspec'
require 'support/routes'
require 'support/wait_for_ajax'

module Delays
  # def visit url
  #   super.tap do
  #     sleep 0.5 unless url.include?('admin/')
  #   end
  # end
end

module Parses
  def parse_response response
    parse_json = JSON(response.body)

    parse_json
  end
end

Capybara.default_selector = :css
Capybara::Screenshot.prune_strategy = :keep_last_run

Warden.test_mode!

RSpec.configure do |config|
  config.include Capybara::DSL
  config.include Rails.application.routes.url_helpers
  config.include Routes
  config.include WaitForAjax
  config.include Warden::Test::Helpers
  config.include Delays
  config.include Parses
  config.after(:each) { Warden.test_reset! }

  config.infer_spec_type_from_file_location!
end