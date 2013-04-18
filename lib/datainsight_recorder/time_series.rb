module DataInsight
  module Recorder
    module TimeSeries
      def self.included(model)
        model.property :start_at, DateTime, required: true
        model.property :end_at, DateTime, required: true
      end

      def validate_time_series_week
        unless end_at.nil? || start_at.nil?
          unless midnight?(start_at)
            return [false, "The time period must start at midnight."]
          end
          unless midnight?(end_at)
            return [false, "The time period must end at midnight."]
          end

          if (end_at.to_date - start_at.to_date) == 7
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
          unless midnight?(start_at)
            return [false, "The time period must start at midnight."]
          end
          true
        end
      end

      def validate_time_series_hour
        unless start_at.nil? || end_at.nil?
          if (end_at - start_at) != Rational(1, 24)
            return [false, "The time period must be an hour."]
          end
          if start_at.minute != 0 || start_at.second != 0 || start_at.second_fraction != 0
            return [false, "The time period must start on the hour."]
          end
        end
        return true
      end

      private
      def midnight?(datetime)
        datetime.hour == 0 && datetime.minute == 0 && datetime.second == 0 && datetime.second_fraction == 0
      end

    end
  end
end
