require 'json'
require 'net/http'
require 'pry'

class GpioServiceTestClient

  @@host = '192.168.200.145'
  @@port = '88331'

  def post(pin, value)
    data = {pin: pin, value: value}.to_json
    req = Net::HTTP::Post.new('/', initheader = {'Content-Type' =>'application/json'})
    req.body = data
    response = Net::HTTP.new(@@host, @@port).start {|http| http.request(req) }
    puts "Response #{response.code} #{response.message}:
    #{response.body}"
  end

end
