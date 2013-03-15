module RSpec
  module Matchers

    def load_property_value(value)
      DataMapperPropertyMatcher.new(:load, value)
    end

    def dump_property_value(value)
      DataMapperPropertyMatcher.new(:dump, value)
    end

    class DataMapperPropertyMatcher
      def initialize(_method, value)
        @method = _method
        @value = value
      end

      def as(expected_result)
        @expected = expected_result
        self
      end

      def matches?(property)
        @actual = property.send(@method, @value)
        equal?(@expected, @actual)
      end

      def description
        "#{@method} #{describe @value} as #{describe @expected}"
      end

      def failure_message_for_should
        "expected: #{@expected.inspect}\n  actual: #{@actual.inspect}"
      end

      private

      def equal?(expected, actual)
        case expected
          when Date then actual == expected && actual.offset == expected.offset
          else actual == expected
        end
      end

      def describe(value)
        value.is_a?(Date) ? value.strftime : value.inspect
      end
    end

  end
end
