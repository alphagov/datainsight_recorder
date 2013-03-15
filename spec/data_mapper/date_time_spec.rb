require "spec_helper"

describe DataMapper::Property::DateTime do

  before :all do
    @default_timezone = DataMapper::Property::DateTime.timezone
  end

  before :each do
    DataMapper::Property::DateTime.timezone = @default_timezone
  end

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
      before :each do
        DataMapper::Property::DateTime.timezone = TZInfo::Timezone.get("Europe/Rome")
      end

      it { should load_property_value(d('2013-01-01 14:00:00 +00:00')).as d('2013-01-01 15:00:00 +01:00') }
      it { should load_property_value(d('2013-06-01 14:00:00 +00:00')).as d('2013-06-01 16:00:00 +02:00') }
    end
  end

  describe "integration tests" do
    class TestModel
      include DataMapper::Resource
      property :id, DataMapper::Property::Serial
      property :tested_at, DateTime
    end

    before(:all) do
      DataInsight::Recorder::DataMapperConfig.configure(:test)
      DataMapper.auto_migrate!
    end

    before(:each) do
      TestModel.destroy!
    end

    it "should save and retrieve datetime properties with DST" do
      TestModel.create(tested_at: d('2013-05-30 10:00:00 +01:00'))

      TestModel.first.tested_at.should equal_date_time d('2013-05-30 10:00:00 +01:00')
    end

    it "should save and retrieve nil datetime properties" do
      TestModel.create(tested_at: nil)

      TestModel.first.tested_at.should be_nil
    end

    it "should query correctly" do
      TestModel.create(tested_at: d('2013-05-30 09:00:00 +01:00'))
      TestModel.create(tested_at: d('2013-05-30 10:00:00 +01:00'))
      TestModel.create(tested_at: d('2013-05-30 11:00:00 +01:00'))

      models = TestModel.all(:tested_at.gt => d('2013-05-30 10:00:00 +01:00'))
      models.should have(1).item
    end

  end
end
