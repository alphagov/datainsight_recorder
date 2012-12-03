require 'rspec'
require 'bundler/setup'
Bundler.require
ENV['RACK_ENV'] = 'test'
require "data_mapper"

require_relative "../lib/datainsight_recorder/datamapper_config"
module TestDataMapperConfig
  extend DataInsight::Recorder::DataMapperConfig

  def self.test_uri
    "sqlite::memory:"
  end
end

Datainsight::Logging.configure(:env => :test)

def should_be_invalid(record, field, message)
  record.valid?.should be_false
  record.errors[field].length.should == 1
  record.errors[field][0].should == message
end
