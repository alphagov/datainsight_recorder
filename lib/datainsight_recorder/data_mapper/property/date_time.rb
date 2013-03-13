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
        tz = TZInfo::Timezone.get("Europe/London")
        date.new_offset(tz.period_for_utc(date).utc_total_offset_rational)
      end

      def to_utc(date)
        date.new_offset(0)
      end
    end
  end
end


