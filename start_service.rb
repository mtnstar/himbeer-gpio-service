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

port = @config['listen_port']
ip = @config['listen_ip']

# start rack server
Rack::Handler::WEBrick.run GpioService.new(gpio), :Port => port, :BindAddress => ip
