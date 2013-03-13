require 'rspec'
require 'bundler/setup'
Bundler.require
ENV['RACK_ENV'] = 'test'
require "data_mapper"

Dir[File.expand_path("../support/**/*.rb", __FILE__)].each {|f| require f}

require_relative "../lib/datainsight_recorder/datamapper_config"

Datainsight::Logging.configure(:env => :test)

def should_be_invalid(record, field, message)
  record.valid?.should be_false
  record.errors[field].length.should == 1
  record.errors[field][0].should == message
end
