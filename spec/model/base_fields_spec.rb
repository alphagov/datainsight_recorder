require_relative "../spec_helper"
require_relative "../../lib/datainsight_recorder/base_fields"

class TestBaseFields
  include DataMapper::Resource
  include DataInsight::Recorder::BaseFields
end

describe "BaseFields" do
  before(:all) do
    TestDataMapperConfig.configure(:test)
  end

  after(:each) do
    TestWeekSeries.destroy!
  end

  it "should add base fields" do
    model = mock()
    model.should_receive(:property).with(:id, DataMapper::Property::Serial)
    model.should_receive(:property).with(:collected_at, DateTime, required: true)
    model.should_receive(:property).with(:source, String, required: true)

    DataInsight::Recorder::BaseFields.included(model)
  end

  it "should require a source" do
    record = TestBaseFields.new(
      collected_at: DateTime.new
    )
    should_be_invalid(record, :source, "Source must not be blank")
  end

  it "should require a collected_at timestamp" do
    record = TestBaseFields.new(
      source: "I made it up"
    )

    should_be_invalid(record, :collected_at, "Collected at must not be blank")
  end
end