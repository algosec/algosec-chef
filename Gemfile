# frozen_string_literal: true

source 'https://rubygems.org'

gem 'algosec-sdk', github: 'algosec/algosec-ruby', branch: 'master'
gem 'berkshelf'
gem 'chef-sugar'
gem 'kitchen-inspec'
gem 'kitchen-vagrant'
gem 'test-kitchen'

group :development do
  gem 'chefspec'
  gem 'cookstyle'
  gem 'foodcritic'
  gem 'guard'
  gem 'guard-foodcritic'
  gem 'guard-rspec'
  gem 'guard-rubocop'
  gem 'rb-readline' if Gem.win_platform?
  gem 'wdm', '>= 0.1.0' if Gem.win_platform?
  gem 'win32console' if Gem.win_platform?
end

group :test do
  gem 'pry-byebug'
end
