require "data_mapper"
require "tzinfo"

module DataMapper
  class Property
    class DateTime

      alias_method :base_dump, :dump
      alias_method :base_load, :load

      def dump(value)
        to_utc(base_dump(value))
      end

      def load(value)
        date = base_load(value)
        date.new_offset(DateTime.timezone.period_for_utc(date).utc_total_offset_rational) unless date.nil?
      end

      def to_utc(date)
        date.new_offset(0)
      end

      class << self
        def timezone
          @timezone ||= TZInfo::Timezone.get("Europe/London")
        end

        def timezone=(timezone)
          @timezone = get_timezone(timezone)
        end

        private

        def get_timezone(timezone)
          case timezone
            when TZInfo::Timezone then timezone
            when ::String then TZInfo::Timezone.get(timezone)
            else raise ArgumentError.new("'#{timezone}' is not a valid timezone argument")
          end
        end
      end

    end
  end
end


