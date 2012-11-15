require "data_mapper"

module DataInsight
  module Recorder
    module BaseFields
      def self.included(model)
        model.property :id, DataMapper::Property::Serial
        model.property :collected_at, DateTime, required: true
        model.property :source, String, required: true
      end
    end
  end
end