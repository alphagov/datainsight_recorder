require "datainsight_logging"
require "yaml"
require 'dm-constraints'
require 'dm-migrations'

module DataInsight
  module Recorder
    class DataMapperConfig
      def self.configure(env=nil)
        config_path = File.join(Dir.pwd, 'config', 'databases.yml')

        config_new = DataMapperConfig.new(File.read(config_path))
        config_new.configure(env)
      end

      def initialize(config_data)
        @config = YAML.load(config_data)
      end

      def configure(env = nil)
        env = env || ENV["RACK_ENV"] || ENV["RAILS_ENV"] || "development"
        raise ArgumentError.new("No database configuration for environment: #{env}") unless @config.has_key? env.to_s

        DataMapper.logger = Logging.logger[DataMapper]
        DataMapper.setup(:default, @config[env.to_s]["uri"])
        DataMapper.finalize
        DataMapper::Model.raise_on_save_failure = true
      end
    end
  end
end
