ENV['RACK_ENV'] = 'test'

require 'rspec'
require 'rack/test'
require 'sinatra'
require 'endpoint_base'
require 'pry-byebug'
require './echo_endpoint'

HUB_STORE        = '538641a050616242f0080000'
HUB_ACCESS_TOKEN = 'd7750b372ad5eafbfa326a7aad2e8817d64c3a2a94f5dc82'
REQUEST_ID       = '5347c18a69702d1ef10c0000'

module RequestHelper
  include Rack::Test::Methods

  def app; described_class end

  def json
    @json ||= JSON.parse(last_response.body)
  end

  def wpost(path, payload = {}, headers = {})
    payload.merge!(request_id: REQUEST_ID)
    headers.merge!('Content-Type' => 'application/json', 'X-Hub-Store' => HUB_STORE, 'X-Hub-Access-Token' => HUB_ACCESS_TOKEN)

    post path, payload.to_json, headers
  end
end

RSpec.configure do |conf|
  conf.include RequestHelper
end
