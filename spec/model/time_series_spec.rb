require_relative "../spec_helper"
require "data_mapper"
require_relative "../../lib/datainsight_recorder/time_series"

class TestTimeSeries
  include DataMapper::Resource
  include DataInsight::Recorder::TimeSeries
end

describe "TimeSeries" do
  it "should add time series fields" do
    model = mock()
    model.should_receive(:property).with(:start_at, DateTime, required: true)
    model.should_receive(:property).with(:end_at, DateTime, required: true)

    DataInsight::Recorder::TimeSeries.included(model)
  end

  describe "validate_time_series_week" do
    # dunno how to do this
    it "should not allow a time period of more than one week"
    it "should not allow a time period of less than one week"
    it "should allow a time period of exactly one week"
  end
end