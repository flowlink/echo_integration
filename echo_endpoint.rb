class EchoEndpoint < EndpointBase::Sinatra::Base
  set :logging, true

  post '/' do
    result 200, 'Echo Success Response'
  end

  post '/echo' do
    @payload.each do |key, value|
      add_value key, value
    end

    result 200
  end

  post '/fail' do
    result 500, 'Echo Fail Response'
  end
end
