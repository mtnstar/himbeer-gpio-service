require_relative '../gpio_service'

describe GpioService, "#hasRequiredKeys" do

  before(:each) do
    gpio = nil
    @gs = GpioService.new(nil, gpio)
  end

  it "return false if data_hash is nil" do
    data_hash = nil
    expect(@gs.hasRequiredKeys(data_hash)).to be(false)
  end

  it "return false if data_hash is not a hash" do
    data_hash = "foo"
    expect(@gs.hasRequiredKeys(data_hash)).to be(false)
  end

  it "return false if value key is missing" do
    data_hash = {pin: 1}
    expect(@gs.hasRequiredKeys(data_hash)).to be(false)
  end

  it "return false if pin key is missing" do
    data_hash = {value: 1}
    expect(@gs.hasRequiredKeys(data_hash)).to be(false)
  end

  it "return true if all required keys are present" do
    data_hash = {pin: 1, value: 1}
    expect(@gs.hasRequiredKeys(data_hash)).to be(true)
  end

end

describe GpioService, "#gpioWrite" do

  before(:each) do
    @gpio = double('gpio')
    @gs = GpioService.new(nil, @gpio)
  end

  it "should not call gpio write if pin is missing" do
    expect(@gpio).to receive(:write).never
    @gs.gpioWrite(nil, 1)
  end

  it "should not call gpio write if value is missing" do
    expect(@gpio).to receive(:write).never
    @gs.gpioWrite(nil, 1)
  end

  it "should call gpio write if value and pin is present" do
    expect(@gpio).to receive(:write).with(1,1).once
    @gs.gpioWrite(1, 1)
  end
end

describe GpioService, "#gpioRead" do

  before(:each) do
    @gpio = double('gpio')
    @gs = GpioService.new(nil, @gpio)
  end

  it "should not call gpio read if pin is missing" do
    expect(@gpio).to receive(:read).never
    @gs.gpioRead(nil)
  end

  it "should not call gpio read" do
    expect(@gpio).to receive(:read).with(1).once
    @gs.gpioRead(1)
  end

end

describe GpioService, "#gpioRead" do

  before(:each) do
    gpio = nil
    @gs = GpioService.new(nil, gpio)
  end

  it "should return error msg" do
    answer = @gs.createErrorAnswer("foo")
    expect(answer).to eq({error: 'GPIO Service: foo'})
  end

end

