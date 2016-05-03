source 'https://rubygems.org'
ruby "2.2.1"

gem 'rails', '4.2.3'
gem 'pg'
gem 'pg_search'
gem 'scoped_search', '~> 2.7.1'
# gem 'sass-rails', '~> 5.0'
# gem 'uglifier', '>= 1.3.0'
# gem 'coffee-rails', '~> 4.1.0'
# gem 'therubyracer', platforms: :ruby
# gem 'jquery-rails'
#gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc
# gem 'bcrypt', '~> 3.1.7'
gem 'unicorn'

group :development do
  gem 'letter_opener'
end

group :development, :test do
  gem 'byebug'
  gem 'web-console', '~> 2.0'
  gem 'spring'

  gem 'dotenv-rails'
end

group :development, :staging, :production do
  # Access Random User Generator API
  gem 'randomuser', github: 'jackbit/randomuser'
  # Generate fake data: names, addresses, phone numbers, etc.
  gem 'faker', '~> 1.5.0'
end

group :production, :staging do
  gem 'heroku_rails_deflate'
  gem 'rails_12factor'
end

group :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'chronic'
  gem 'database_cleaner'
  gem 'capybara'
  gem 'poltergeist'
  gem 'capybara-screenshot'
  gem 'launchy'
  gem 'timecop'
end

# Required for font path of Bootstrap
# gem 'rack-rewrite'
#
# gem 'angular-rails-templates'
# gem 'sprockets'

# APPLICATION PROGRAMMING INTERFACE (API)
gem 'grape', '~> 0.9.0'
gem 'grape-swagger', '~> 0.8.0'
gem 'grape-swagger-rails', git: 'https://github.com/ruby-grape/grape-swagger-rails'
gem 'rack-cors', :require => 'rack/cors'

# Flexible authentication solution for Rails with Warden
gem 'devise', :git => 'https://github.com/plataformatec/devise.git'
# Extracted Token Authenticatable module of devise
gem 'devise-token_authenticatable'
# asynchronously send devise email
gem 'devise-async'
gem 'devise_security_extension'
gem 'rails_email_validator'

# XML/JSON API responses
gem 'acts_as_api', '~> 0.4.2'

# Support for build a simple, robust and scaleable authorization system.
gem 'pundit'

#Support for unit system
gem 'ruby-units', git: 'https://github.com/apecherin/ruby-units.git'

#Additional utils
gem 'settingslogic'
gem 'deep_cloneable', '~> 2.1.1'
#A Scope & Engine based paginator
gem 'kaminari'
# File uploads
gem 'carrierwave', :git => 'git://github.com/jnicklas/carrierwave.git'
gem 'fog'
gem 'mini_magick'
gem 'paperclip', :git => 'git://github.com/thoughtbot/paperclip.git'
#Search support
gem 'elasticsearch-model'
gem 'elasticsearch-rails'
group :production, :staging do
  gem 'bonsai-elasticsearch-rails'
end

# gem 'active_model_serializers', git: 'https://github.com/rails-api/active_model_serializers.git' # Untill 0.9.0 is released
