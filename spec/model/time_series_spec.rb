require_relative "../spec_helper"
require "data_mapper"
require_relative "../../lib/datainsight_recorder/base_fields"
require_relative "../../lib/datainsight_recorder/time_series"

class TestWeekSeries
  include DataMapper::Resource
  include DataInsight::Recorder::BaseFields
  include DataInsight::Recorder::TimeSeries

  validates_with_method :validate_time_series_week
end

class TestDaySeries
  include DataMapper::Resource
  include DataInsight::Recorder::BaseFields
  include DataInsight::Recorder::TimeSeries

  validates_with_method :validate_time_series_day
end

class TestHourSeries
  include DataMapper::Resource
  include DataInsight::Recorder::BaseFields
  include DataInsight::Recorder::TimeSeries

  validates_with_method :validate_time_series_hour
end

describe "TimeSeries" do
  before(:all) do
    TestDataMapperConfig.configure(:test)
  end

  after(:each) do
    TestWeekSeries.destroy!
    TestDaySeries.destroy!
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

  describe "validate_time_series_day" do
    it "should not allow a time period of more than a day" do
      record = TestDaySeries.new(
        :source => "My source",
        :collected_at => DateTime.now,
        :start_at => DateTime.new(2012, 1, 1),
        :end_at => DateTime.new(2012, 1, 2, 1)
      )

      should_be_invalid(record, :validate_time_series_day, "The time period must be a day.")
    end

    it "should not allow a time period of less than a day" do
      record = TestDaySeries.new(
        :source => "My source",
        :collected_at => DateTime.now,
        :start_at => DateTime.new(2012, 1, 1),
        :end_at => DateTime.new(2012, 1, 1, 23)
      )

      should_be_invalid(record, :validate_time_series_day, "The time period must be a day.")
    end

    it "should not allow a time period that does not start at midnight" do
      record = TestDaySeries.new(
        :source => "My source",
        :collected_at => DateTime.now,
        :start_at => DateTime.new(2012, 1, 1, 1),
        :end_at => DateTime.new(2012, 1, 2, 1)
      )

      should_be_invalid(record, :validate_time_series_day, "The time period must start at midnight.")
    end

    it "should allow a time period of exactly one day that starts at midnight" do
      record = TestDaySeries.new(
        :source => "My source",
        :collected_at => DateTime.now,
        :start_at => DateTime.new(2012, 1, 1),
        :end_at => DateTime.new(2012, 1, 2)
      )

      record.valid?.should be_true
    end
  end

  describe "validate_time_series_hour" do
    it "should not allow a time period of more than an hour" do
      record = TestHourSeries.new(
        :source => "My source",
        :collected_at => DateTime.now,
        :start_at => DateTime.new(2012, 1, 1, 0),
        :end_at => DateTime.new(2012, 1, 1, 2)
      )

      should_be_invalid(record, :validate_time_series_hour, "The time period must be an hour.")
    end

    it "should not allow a time period of less than an hour" do
      record = TestHourSeries.new(
        :source => "My source",
        :collected_at => DateTime.now,
        :start_at => DateTime.new(2012, 1, 1, 0),
        :end_at => DateTime.new(2012, 1, 1, 1, 30)
      )

      should_be_invalid(record, :validate_time_series_hour, "The time period must be an hour.")
    end

    it "should not allow a time period that does not start on the hour" do
      record = TestHourSeries.new(
        :source => "My source",
        :collected_at => DateTime.now,
        :start_at => DateTime.new(2012, 1, 1, 0, 30),
        :end_at => DateTime.new(2012, 1, 1, 1, 30)
      )

      should_be_invalid(record, :validate_time_series_hour, "The time period must start on the hour.")
    end

    it "should allow a valid time period" do
      record = TestHourSeries.new(
        :source => "My source",
        :collected_at => DateTime.now,
        :start_at => DateTime.new(2012, 1, 1, 0),
        :end_at => DateTime.new(2012, 1, 1, 1)
      )

      record.valid?.should be_true
    end
  end
end
