require_relative "../spec_helper"
require_relative "../../lib/datainsight_recorder/datamapper_config"

TEST_CONFIG = <<-HERE
development:
  uri: dev-uri

test:
  uri: test-uri
HERE

describe "DataMapperConfig" do
  it "should initialize datamapper with development uri" do
    DataMapper.should_receive(:setup).with(:default, "dev-uri")

    config_new = DataInsight::Recorder::DataMapperConfig.new(TEST_CONFIG)
    config_new.configure(:development)
  end

  it "should raise an error if the selected environment is not present in the configuration" do
    lambda {
      config_new = DataInsight::Recorder::DataMapperConfig.new(TEST_CONFIG)
      config_new.configure(:invalid_config)
    }.should raise_error(ArgumentError)
  end

  before(:each) do
    @original_rack_env = ENV["RACK_ENV"]
    @original_rails_env = ENV["RAILS_ENV"]

    ENV.delete("RACK_ENV")
    ENV.delete("RAILS_ENV")
  end

  after(:each) do
    ENV["RACK_ENV"] = @original_rack_env
    ENV["RAILS_ENV"] = @original_rails_env
  end

  it "should select the environment defined by RACK_ENV variable" do
    ENV["RACK_ENV"] = "development"

    DataMapper.should_receive(:setup).with(:default, "dev-uri")

    config_new = DataInsight::Recorder::DataMapperConfig.new(TEST_CONFIG)
    config_new.configure
  end

  it "should select the environment defined by RAILS_ENV variable if RACK_ENV is missing" do
    ENV["RAILS_ENV"] = "test"

    DataMapper.should_receive(:setup).with(:default, "test-uri")

    config_new = DataInsight::Recorder::DataMapperConfig.new(TEST_CONFIG)
    config_new.configure

  end

  it "should select development if RAILS_ENV and RACK_ENV is missing" do
    DataMapper.should_receive(:setup).with(:default, "dev-uri")

    config_new = DataInsight::Recorder::DataMapperConfig.new(TEST_CONFIG)
    config_new.configure

  end

end