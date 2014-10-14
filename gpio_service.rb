module GpioService
  def post_init
    puts "-- someone connected to the echo server!"
  end

  def receive_data(data)
    binding.pry
    p "id " + data['id'] + " value " + data['value']
    send_data ">>> you sent: #{id}"
  end
end
