require 'eventmachine'

class Echo < EventMachine::Connection
  def post_init
    data = id: 1, value: 0
    send_data(data)
  end

  def receive_data(data)
    p data
  end
end

EventMachine.run {
  EventMachine::connect '127.0.0.1', 88331, Echo
}
