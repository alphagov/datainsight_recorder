require "spec_helper"

describe DataMapper::Property::DateTime do

  before :each do
    model = double("model", repository_name: "repo")
    name = double("name")

    @date_time_property = DataMapper::Property::DateTime.new(model, name)

  end

  it "should dump dates as UTC" do
    dumped_value = @date_time_property.dump(DateTime.new(2013, 3, 10, 18, 30, 0, '+5'))
    dumped_value.should equal_date_time DateTime.new(2013, 3, 10, 13, 30, 0, '+0')
  end

end
