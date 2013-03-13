require "spec_helper"

describe DataMapper::Property::DateTime do

  subject(:date_time_property) {
    model = double("model", repository_name: "repo")
    name = double("name")
    DataMapper::Property::DateTime.new(model, name)
  }

  it { should load_property_value(nil).as nil }

  describe "should dump dates as UTC" do
    it { should dump_property_value(d('2013-03-10 18:30:00+05:00')).as d('2013-03-10 13:30:00+00:00') }
  end

  describe "load dates with appropriate DST" do
    it { should load_property_value(d('2013-01-01 14:00:00 +00:00')).as d('2013-01-01 14:00:00 +00:00') }
    it { should load_property_value(d('2013-03-31 00:00:00 +00:00')).as d('2013-03-31 00:00:00 +00:00') }
    it { should load_property_value(d('2013-03-31 01:00:00 +00:00')).as d('2013-03-31 02:00:00 +01:00') } # time of switch to BST for 2013 - source: https://www.gov.uk/when-do-the-clocks-change
    it { should load_property_value(d('2013-06-01 14:00:00 +00:00')).as d('2013-06-01 15:00:00 +01:00') }
    it { should load_property_value(d('2013-10-27 00:00:00 +00:00')).as d('2013-10-27 01:00:00 +01:00') }
    it { should load_property_value(d('2013-10-27 01:00:00 +00:00')).as d('2013-10-27 01:00:00 +00:00') } # tim of switch back to GMT for 2013 - source: https://www.gov.uk/when-do-the-clocks-change
  end

  describe "timezone configuration" do
    it "should allow configuration of timezone" do
      DataMapper::Property::DateTime.timezone = TZInfo::Timezone.get("Europe/Athens")
      DataMapper::Property::DateTime.timezone.should == TZInfo::Timezone.get("Europe/Athens")
    end

    it "should allow configuration of timezone as a String" do
      DataMapper::Property::DateTime.timezone = "Europe/Moscow"
      DataMapper::Property::DateTime.timezone.should == TZInfo::Timezone.get("Europe/Moscow")
    end

    it "should raise exception if timezone name is invalid" do
      lambda { DataMapper::Property::DateTime.timezone = "Europe/Hackney" }.should raise_exception
    end

    it "should raise exception if timezone argument is neither a timezone or a stirng" do
      lambda { DataMapper::Property::DateTime.timezone = :PST }.should raise_exception
    end

    describe "with timezone set to Europe/Rome" do
      before :all do
        DataMapper::Property::DateTime.timezone = TZInfo::Timezone.get("Europe/Rome")
      end

      it { should load_property_value(d('2013-01-01 14:00:00 +00:00')).as d('2013-01-01 15:00:00 +01:00') }
      it { should load_property_value(d('2013-06-01 14:00:00 +00:00')).as d('2013-06-01 16:00:00 +02:00') }
    end
  end
end