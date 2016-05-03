ENV['RAILS_ENV'] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'rails/application'
require 'capybara/poltergeist'
require 'helper.rb'

Capybara.javascript_driver = :poltergeist

RSpec.configure do |config|
  config.mock_with :rspec

  config.include Helper
  config.include FactoryGirl::Syntax::Methods

  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  # config.use_transactional_fixtures = true
  config.use_transactional_fixtures = false
  config.order = "random"

  config.before(:suite) do
    DatabaseCleaner.strategy = :deletion
    DatabaseCleaner.clean_with :deletion
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  # config.after { |example_group| p page.driver.console_messages if example_group.example.exception }

  config.after(:each, time_travel: true) { Timecop.return }
end