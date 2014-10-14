require 'eventmachine'
require 'json'

class TestClient < EventMachine::Connection
  def post_init
    data = {pin: 0, value: 0}.to_json
    send_data(data)
  end

  def receive_data(data)
    p data
  end
end

EventMachine.run {
  EventMachine::connect '192.168.200.145', 88331, TestClient
}
