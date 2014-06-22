source 'https://rubygems.org'
ruby '2.0.0'

gem 'bootstrap-sass'
gem 'coffee-rails'
gem 'rails'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'bcrypt'
gem 'bcrypt-ruby'
gem 'bootstrap_form'
gem 'fabrication'
gem 'faker'
gem 'redis'
gem 'sidekiq'
gem 'mailgunner', '~> 1.3.0'

group :development do
  gem 'sqlite3'
  gem 'pry'
  gem 'pry-nav'
  gem 'thin'
  gem "better_errors"
  gem "binding_of_caller"
  gem "letter_opener"
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
end

group :development, :test do
  gem 'rspec-rails', '2.14.1'
end

group :test do
  gem 'shoulda-matchers'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'capybara-email', github: 'dockyard/capybara-email'
end

