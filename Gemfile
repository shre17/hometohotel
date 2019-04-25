source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'device_detector'
gem 'devise_invitable'
gem 'devise_token_auth'
gem  'twilio-ruby'
gem 'rails', '~> 5.2.0'
gem 'i18n'
gem 'active_model_serializers'
gem 'money'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# For design and css
gem 'bootstrap', '~> 4.1'
gem 'jquery-slick-rails'
gem 'jquery-rails', '~> 4.3', '>= 4.3.3'
gem 'bootstrap-datepicker-rails'

# For user authentication
gem 'devise'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem 'awesome_print'

# For haml
gem 'haml', '~> 5.0', '>= 5.0.4'
gem 'html2haml'

# For document or image upload
gem 'carrierwave', '~> 1.0'
gem 'carrierwave-base64'
gem 'mini_magick'
# gem 'rmagick', '2.16.0'

# For nested form
gem "cocoon"

# For searching
gem 'pg_search', '~> 2.1', '>= 2.1.2'

# For dummy data
gem 'faker', :git => 'https://github.com/stympy/faker.git', :branch => 'master'

# For latitude n longitude
# gem 'geocoder', '~> 1.4', '>= 1.4.9'
gem 'geocoder'

# For country list
gem 'countries'
gem 'country_select', '~> 3.1'
# gem 'country_state_select'
gem 'city-state'


# Payment Gateway
gem 'activemerchant'
gem "braintree", "~> 2.90.0"

# User rails varibale in js file
gem 'gon'
gem 'rabl-rails'

# For pdf files
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'

# Google map
gem 'gmaps4rails'

# Calender
gem 'fullcalendar-rails'
gem 'momentjs-rails'

# Pagination
gem 'will_paginate', '~> 3.1.0'

gem 'money-open-exchange-rates'

# For Admin Panel
gem 'activeadmin', '~> 1.3', '>= 1.3.1'

gem "autoprefixer-rails"

gem 'fog'
gem 'chosen-rails', '~> 1.8', '>= 1.8.7'
gem 'alertifyjs-rails'

gem 'lightbox-bootstrap-rails', '5.1.0.1'

gem 'whenever', require: false
gem "rolify"

group :development, :test do
  gem 'pry-byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # gem 'rails-erd'
  gem 'capistrano',               '~> 3.5'
  gem 'capistrano-rails',         '~> 1.1.6'
  gem 'capistrano-rvm',           '~> 0.1.2'
  gem 'capistrano-passenger'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15', '< 4.0'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end

gem 'jquery-datatables-rails', '~> 3.4.0'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# For heroku assets compile
gem 'rails_12factor', group: :production
