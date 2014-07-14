source 'https://rubygems.org'

gem 'sinatra'
gem 'tilt', '~> 1.4.1'
gem 'tilt-jbuilder', require: 'sinatra/jbuilder'

group :development do
  gem 'shotgun'
  gem 'pry'
  gem 'byebug'
end

group :production do
  gem 'foreman'
  gem 'unicorn'
end

group :test do
  gem 'rspec'
  gem 'rack-test'
end

gem 'endpoint_base', github: 'spree/endpoint_base'
    #path: '../endpoint_base'
