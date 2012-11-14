module DataInsight
  module Recorder
    module TimeSeries
      def self.included(model)
        model.property :start_at, DateTime, required: true
        model.property :end_at, DateTime, required: true
      end

      def validate_time_series_week
        unless end_at.nil? || start_at.nil?
          if (end_at - start_at) == 6
            true
          else
            [false, "The time between start and end should be a week."]
          end
        end
      end
    end
  end
end