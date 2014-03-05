class EchoEndpoint < EndpointBase::Sinatra::Base
  set :logging, true

  post '/' do
    set_summary 'Echo Success Response'
    process_result 200
  end

  # post '/echo' do
  #   echo = @message[:payload]
  #   echo[:message_id] = @message[:message_id]
  #   echo.delete :parameters

  #   process_result 200, echo
  # end

  post '/fail' do
    set_summary 'Echo Fail Response'
    process_result 500
  end
end
