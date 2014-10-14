require 'json'
class GpioService < EventMachine::Connection

  attr_reader :gpio

  def initialize(gpio)
    @gpio = gpio
  end

  def receive_data(data)
    jdata = JSON.parse(data)
    pin = jdata['pin']
    value = jdata['value']
    p "setting pin: #{pin} value: #{value}"
    gpio.write(pin,value)
  end

end
