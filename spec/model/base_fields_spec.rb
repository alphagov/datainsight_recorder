require_relative "../spec_helper"
require_relative "../../lib/datainsight_recorder/base_fields"

describe "BaseFields" do
  it "should add base fields" do
    model = mock()
    model.should_receive(:property).with(:id, DataMapper::Property::Serial)
    model.should_receive(:property).with(:collected_at, DateTime, required: true)
    model.should_receive(:property).with(:collector, String, required: true)

    DataInsight::Recorder::BaseFields.included(model)
  end
end