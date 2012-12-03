require_relative "../spec_helper"
require "data_mapper"
require_relative "../../lib/datainsight_recorder/time_series"

class TestWeekSeries
  include DataMapper::Resource
  include DataInsight::Recorder::BaseFields
  include DataInsight::Recorder::TimeSeries

  validates_with_method :validate_time_series_week
end

describe "TimeSeries" do
  before(:all) do
    TestDataMapperConfig.configure(:test)
  end

  after(:each) do
    TestWeekSeries.destroy!
  end
  it "should add time series fields" do
    model = mock()
    model.should_receive(:property).with(:start_at, DateTime, required: true)
    model.should_receive(:property).with(:end_at, DateTime, required: true)

    DataInsight::Recorder::TimeSeries.included(model)
  end

  it "should require a start_at timestamp" do
    record = TestWeekSeries.new(
      source: "Example",
      collected_at: DateTime.new,
      end_at: DateTime.new(2012, 1, 8)
    )
    should_be_invalid(record, :start_at, "Start at must not be blank")
  end

  it "should require an end_at timestamp" do
    record = TestWeekSeries.new(
      source: "Example",
      collected_at: DateTime.new,
      start_at: DateTime.new(2012, 1, 8)
    )
    should_be_invalid(record, :end_at, "End at must not be blank")
  end

  describe "validate_time_series_week" do
    it "should not allow a time period of more than one week" do
      record = TestWeekSeries.new(
        :source => "My Source",
        :collected_at => DateTime.new,
        :start_at => DateTime.new(2012, 1, 1),
        :end_at => DateTime.new(2012, 1, 10)
      )
      should_be_invalid(record, :validate_time_series_week, "The time between start and end should be a week.")
    end

    it "should not allow a time period of less than one week" do
      record = TestWeekSeries.new(
        :source => "My Source",
        :collected_at => DateTime.new,
        :start_at => DateTime.new(2012, 1, 1),
        :end_at => DateTime.new(2012, 1, 2)
      )
      should_be_invalid(record, :validate_time_series_week, "The time between start and end should be a week.")
    end

    it "should allow a time period of exactly one week" do
      record = TestWeekSeries.new(
        :source => "My Source",
        :collected_at => DateTime.new,
        :start_at => DateTime.new(2012, 1, 1),
        :end_at => DateTime.new(2012, 1, 8)
      )
      
      record.valid?.should be_true
    end
  end
end