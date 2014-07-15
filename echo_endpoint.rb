require 'hub/samples'

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
    quantity    = (@config['quantity'] || 1).to_i

    if object_type.nil?
      result 500, "You must send the 'object_type' parameter."
    else
      quantity.times do |i|
        object = sample_object(object_type, i)

        add_object object_type.singularize, object
      end

      add_parameter 'last_updated_at', Time.now if last_updated_at

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

          object[attribute] = value
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

  post '/slow' do
    if (delay = @payload['parameters'].to_h['delay'].to_i) > 0
      sleep delay
    end

    result 200
  end

  post '/random' do
    result [200, 500][rand(2)]
  end

  def sample_object(object_type, index = 0)
    begin
      base = "Hub::Samples::#{object_type.singularize.titleize}".constantize.object[object_type]
      base = base.clone
    rescue
      base = { 'status' => 'awesome' }
    end

    id = "#{Time.now.year}-#{Time.now.month}-#{Time.now.day}-#{Time.now.hour}-#{index}"

    base['id'] = id

    base
  end

  def last_updated_at
    @last_updated_at ||= Time.parse(@config['last_updated_at'])
  rescue
  end
end
