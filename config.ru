require 'rubygems'
require 'bundler'

Bundler.require(:default)
require "./echo_endpoint"
run EchoEndpoint
