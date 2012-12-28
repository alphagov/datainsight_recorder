require "datainsight_logging"
require 'dm-constraints'
require 'dm-migrations'

module DataInsight
  module Recorder
    module DataMapperConfig
      def configure(env=ENV["RACK_ENV"] || ENV["RAILS_ENV"])
        DataMapper.logger = Logging.logger[DataMapper]
        case (env or "default").to_sym
          when :test
            self.configure_test
          when :production
            self.configure_production
          else
            self.configure_development
        end
        DataMapper::Model.raise_on_save_failure = true
      end

      def development_uri
        raise NotImplementedError
      end

      def configure_development
        DataMapper.setup(:default, development_uri)
        DataMapper.finalize
        DataMapper.auto_upgrade!
      end

      def production_uri
        raise NotImplementedError
      end

      def configure_production
        DataMapper.setup(:default, production_uri)
        DataMapper.finalize
        DataMapper.auto_upgrade!
      end

      def test_uri
        raise NotImplementedError
      end

      def configure_test
        DataMapper.setup(:default, test_uri)
        DataMapper.finalize
        DataMapper.auto_migrate!
      end
    end
  end
end
