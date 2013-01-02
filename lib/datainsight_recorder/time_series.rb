module DataInsight
  module Recorder
    module TimeSeries
      def self.included(model)
        model.property :start_at, DateTime, required: true
        model.property :end_at, DateTime, required: true
      end

      def validate_time_series_week
        unless end_at.nil? || start_at.nil?
          if (end_at - start_at) == 7
            true
          else
            [false, "The time between start and end should be a week."]
          end
        end
      end

      def validate_time_series_day

        unless start_at.nil? || end_at.nil?
          if (end_at - start_at) != 1
            return [false, "The time period must be a day."]
          end
          if start_at.hour != 0 || start_at.minute != 0 || start_at.second != 0 || start_at.second_fraction != 0
            return [false, "The time period must start at midnight."]
          end
          true
        end
      end
    end
  end
end
