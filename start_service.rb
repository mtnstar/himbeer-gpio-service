require 'eventmachine'
require 'yaml'
require 'pry'
require_relative 'gpio_service'

@config = YAML.load_file('config.yaml')

# setup gpio ports

# start eventmachine server
EventMachine::run {
  listen_ip = @config['listen_ip']
  listen_port = @config['listen_port']
  EventMachine::start_server listen_ip, listen_port, GpioService
  p "running gpio service on #{listen_ip}:#{listen_port}"
}
