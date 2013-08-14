class EchoEndpoint < EndpointBase

  set :logging, true

  post '/' do
    process_result 200, { message_id: @message[:message_id],
                          received: @message }
  end

  post '/echo' do
    process_result 200, @message
  end

  post '/fail' do
    process_result 500, { message_id: @message[:message_id],
                          received: @message }
  end
end
