class EchoEndpoint < EndpointBase

  set :logging, true

  post '/' do
    process_result 200, { message_id: @message[:message_id],
                          received: @message[:payload] }
  end

  post '/echo' do
    echo = @message[:payload]
    echo[:message_id] = @message[:message_id]
    echo.delete :parameters

    process_result 200, echo
  end

  post '/fail' do
    process_result 500, { message_id: @message[:message_id],
                          received: @message[:payload] }
  end
end
