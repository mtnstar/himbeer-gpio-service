require 'eventmachine'
require 'yaml'
require 'wiringpi'
require_relative 'gpio_service'

@config = YAML.load_file('config.yaml')

# setup gpio ports
gpio = WiringPi::GPIO.new

gpios = @config['gpio']
gpios.each do |g|
  pin = g[0]
  mode = Kernel.const_get(g[1])
  gpio.mode(pin, mode)
end


# start eventmachine server
EventMachine::run {
  listen_ip = @config['listen_ip']
  listen_port = @config['listen_port']
  EventMachine::start_server(listen_ip, listen_port, GpioService, gpio)
  p "running gpio service on #{listen_ip}:#{listen_port}"
}
