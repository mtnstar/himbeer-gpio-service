require 'json'
require 'rack'
require 'yaml'

class GpioService

  TYPE_PWM = 'pwm'

  @@required_keys = ["pin"]
  @@http_success = '200'

  attr_reader :gpio

  def initialize(gpio)
    @gpio = gpio
  end

  def call(env)
    req = Rack::Request.new(env)
    data = req.body.read

    data_hash = JSON.parse(data)

    p "received: #{data}"

    if hasRequiredKeys(data_hash)
      pin = data_hash['pin'].to_i
      value = data_hash['value']
      type = data_hash['type']
      unless value.nil?
        gpioWrite(pin, value.to_i, type)
      end
      answer = gpioRead(pin).to_json
    else
      answer = getErrorAnswerMissingKey()
    end
    p answer
    return response(@@http_success, answer)
  end

  def response(error_code, data)
    [error_code, {'Content-Type' => 'application/json'}, [data]]
  end

  def gpioWrite(pin, value, type)
    unless pin.nil? || value.nil?
      p "writing pin: #{pin} value: #{value}"
      if TYPE_PWM == type
        gpio.pwmWrite(pin,value)
      else
        gpio.write(pin,value)
      end
    end
  end

  def gpioRead(pin)
    unless pin.nil?
      value = gpio.read(pin)
      p "reading pin: #{pin} value: #{value}"
    end
    {"pin" => pin, "value" => value}
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
    {"error" => error_msg}
  end

end
