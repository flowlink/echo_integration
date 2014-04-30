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

  post '/ready' do
    code = 500
    summary = 'Payload was not very interesting.'

    @payload.each do |key, value|
      next if %w{request_id parameters}.include? key

      if value.is_a? Hash
        if value['status'] == 'ready'
          code = 200
          summary = "The '#{key}' object is ready!"
        else
          code = 500
          summary = "The '#{key}' object is invalid for this action, it's 'status' MUST be 'ready', but it WAS '#{value['status']}'."
        end
      else
        code = 500
        summary = "The '#{key}' must be an object, and it was a #{value.class}."
      end
    end

    result code, summary
  end

  post '/get_objects' do
    object_type = @config['object_type']
    quantity    = @config['quantity'] || 1

    if object_type.nil?
      result 500, "You must send the 'object_type' parameter."
    else

      quantity.to_i.times do |i|
        id = "#{Time.now.year}-#{Time.now.month}-#{Time.now.day}-#{Time.now.hour}-#{i}"

        add_object object_type.singularize, { id: id,
                                              status: 'awesome' }
      end
      result 200, "Here are #{quantity} x '#{object_type}'"
    end
  end

  post '/set_attr' do
    attribute = @config['attribute'] || 'status'
    value     = @config['value'] || 'shipped'

    @payload.each do |key, object|
      next if %w{request_id parameters}.include? key

      if object.is_a? Hash
        if object.key? attribute

          object['attribute'] = value
          add_object key.to_sym, object
          result 200, "Set #{key}'s '#{attribute}' attribute to '#{value}'"
          break
        else
          result 500, "Object '#{key}' doesn't have a '#{attribute}' attribute"
          break
        end
      else
        result 500, "Object '#{key}' is not a hash."
        break
      end
    end
  end
end
