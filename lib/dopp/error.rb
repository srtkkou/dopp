# frozen_string_literal: true

module Dopp
  class Error < StandardError
    class << self
      # Check value using "is_a?" with expected class.
      # @param [Object] value Value.
      # @param [Class] expected Expected class.
      def check_is_a!(value, expected)
        return if value.is_a?(expected)
        # Raise error.
        raise(self.new("#{value}(#{value.class.name}) " +
          "using 'is_a?' with #{expected.name} should be true."))
      end

      # Check value using ">" with expected value.
      # @param [Object] value Value.
      # @param [Class] expected Expected value.
      def check_gt!(value, expected)
        return if (value > expected)
        # Raise error.
        raise(self.new("#{value} should be " +
          "greater than #{expected}."))
      end

      # Check value using ">=" with expected value.
      # @param [Object] value Value.
      # @param [Class] expected Expected value.
      def check_gteq!(value, expected)
        return if (value >= expected)
        # Raise error.
        raise(self.new("#{value} should be " +
          "greater than or equal to #{expected}."))
      end
    end
  end
end
