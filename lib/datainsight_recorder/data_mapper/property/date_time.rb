require "data_mapper"

module DataMapper
  class Property
    class DateTime
      alias_method :base_dump, :dump

      def dump(value)
        to_utc(base_dump(value))
      end

      def to_utc(date)
        date.new_offset(0)
      end
    end
  end
end


