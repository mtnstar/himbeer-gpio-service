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
