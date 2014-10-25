require 'json'
require 'rack'
require 'yaml'

class GpioService

  @@required_keys = ["pin", "value"]
  @@http_success = '200'

  attr_reader :gpio

  def initialize(gpio)
    @gpio = gpio
  end

  def call(env)
    req = Rack::Request.new(env)
    data = req.body.read

    data_hash = JSON.parse(data)
    if hasRequiredKeys(data_hash)
      pin = data_hash['pin']
      value = data_hash['value']
      gpioWrite(pin, value)
      answer = gpioRead(pin).to_json
    else
      answer = getErrorAnswerMissingKey()
    end
    return response(@@http_success, data_hash.to_json)
  end

  def response(error_code, data)
    [error_code, {'Content-Type' => 'application/json'}, [data]]
  end

  def gpioWrite(pin, value)
    unless pin.nil? || value.nil?
      p "writing pin: #{pin} value: #{value}"
      gpio.write(pin,value)
    end
  end

  def gpioRead(pin)
    unless pin.nil?
      value = gpio.read(pin)
      {pin: pin, value: value}
    end
  end

  def hasRequiredKeys(data_hash)
    unless data_hash.is_a?(Hash)
      return false
    end

    @@required_keys.each do |k|
      unless data_hash.has_key?(k)
        return false
      end
    end
    return true
  end

  def getErrorAnswerMissingKey()
    createErrorAnswer('Invalid json data received')
  end

  def createErrorAnswer(msg)
    error_msg = 'GPIO Service: ' + msg
    {error: error_msg}
  end

end
