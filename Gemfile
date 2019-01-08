source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

gem 'bootsnap', '>= 1.1.0', require: false
gem 'devise'
gem 'faker', require: false
gem 'haml'
gem 'jbuilder', '~> 2.5'
gem 'pagy'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'rails', '~> 5.2.1'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'

group :development, :test do
  gem 'rspec-rails', '~> 3.8'
end

group :development, :production do
  gem 'bootstrap-sass'
  gem 'coffee-rails', '~> 4.2', require: false
  gem 'font-awesome-rails'
  gem 'jquery-rails'
  gem 'sass-rails', '~> 5.0'
end

group :development do
  gem 'brakeman'
  gem 'fasterer', require: false
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'pry', require: false
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'chromedriver-helper'
  gem 'rails-controller-testing'
  gem 'rspec'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers'
  gem 'simplecov'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
