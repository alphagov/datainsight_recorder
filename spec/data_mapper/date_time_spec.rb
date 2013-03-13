require "spec_helper"

describe DataMapper::Property::DateTime do

  before :each do
    model = double("model", repository_name: "repo")
    name = double("name")

    @date_time_property = DataMapper::Property::DateTime.new(model, name)

  end

  it "should dump dates as UTC" do
    dumped_value = @date_time_property.dump(d('2013-03-10 18:30:00+05:00'))
    dumped_value.should equal_date_time d('2013-03-10 13:30:00+00:00')
  end

  it "should load summer dates with DST timezone" do
    @date_time_property.load(d('2013-01-01 14:00:00 +00:00')).should equal_date_time d('2013-01-01 14:00:00 +00:00')
    @date_time_property.load(d('2013-03-31 00:00:00 +00:00')).should equal_date_time d('2013-03-31 00:00:00 +00:00')
    @date_time_property.load(d('2013-03-31 01:00:00 +00:00')).should equal_date_time d('2013-03-31 02:00:00 +01:00') # date of switch to BST for 2013 - source: https://www.gov.uk/when-do-the-clocks-change
    @date_time_property.load(d('2013-06-01 14:00:00 +00:00')).should equal_date_time d('2013-06-01 15:00:00 +01:00')
    @date_time_property.load(d('2013-10-27 00:00:00 +00:00')).should equal_date_time d('2013-10-27 01:00:00 +01:00')
    @date_time_property.load(d('2013-10-27 01:00:00 +00:00')).should equal_date_time d('2013-10-27 01:00:00 +00:00') # date of switch back to GMT for 2013 - source: https://www.gov.uk/when-do-the-clocks-change
  end
end
