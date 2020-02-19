# frozen_string_literal: true

module Dopp
  # Errors.
  module Error
    # Application error.
    class ApplicationError < StandardError; end

    module_function

    # Check value using "is_a?" with expected class.
    # @param [Object] value Value.
    # @param [Class] expected Expected class.
    def check_is_a!(value, expected)
      return if value.is_a?(expected)

      msg = "#{value}'s class #{value.class.name} "\
        "should be 'is_a?' with #{expected.name}."
      raise ApplicationError, msg
    end

    # Check value using "<" with expected value.
    # @param [Object] value Value.
    # @param [Numeric] expected Expected value.
    def check_lt!(value, expected)
      return if value < expected

      msg = "#{value} should be less than #{expected}."
      raise ApplicationError, msg
    end

    # Check value using "<=" with expected value.
    # @param [Object] value Value.
    # @param [Numeric] expected Expected value.
    def check_lteq!(value, expected)
      return if value <= expected

      msg = "#{value} should be less than "\
        "or equal to #{expected}."
      raise ApplicationError, msg
    end

    # Check value using ">" with expected value.
    # @param [Object] value Value.
    # @param [Numeric] expected Expected value.
    def check_gt!(value, expected)
      return if value > expected

      msg = "#{value} should be greater than #{expected}."
      raise ApplicationError, msg
    end

    # Check value using ">=" with expected value.
    # @param [Object] value Value.
    # @param [Numeric] expected Expected value.
    def check_gteq!(value, expected)
      return if value >= expected

      msg = "#{value} should be greater than "\
        "or equal to #{expected}."
      raise ApplicationError, msg
    end

    # Check value using "include?" with expected value.
    # @param [Object] value Value.
    # @param [Enumerable] expected Expected value.
    def check_include!(value, expected)
      return if expected.include?(value)

      msg = "#{value} should be included in #{expected}."
      raise ApplicationError, msg
    end

    # Check value using "include?" with expected value.
    # @param [Object] value Value.
    # @param [Regexp] expected Expected value.
    def check_matches!(value, expected)
      return if expected.match?(value)

      msg = "#{value} should match #{expected}."
      raise ApplicationError, msg
    end
  end
end
