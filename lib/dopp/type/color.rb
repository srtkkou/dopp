# frozen_string_literal: true

require 'dopp/error'

module Dopp
  module Type
    # PDF color.
    class Color
      include ::Dopp::Error

      # CSS color code format.
      CODE_FORMAT ||=
        /\A#?(?<r>\h{2})(?<g>\h{2})(?<b>\h{2})\z/.freeze

      # Initialize color.
      def initialize(code)
        check_matches!(code, CODE_FORMAT)
        hex_digits = CODE_FORMAT.match(code).captures
        @rgb = hex_digits.map { |s| s.to_i(16) }
      end

      # Convert to string.
      # @return [String] Content.
      def to_s
        code = @rgb.map do |v|
          format('%<value>02x', value: v)
        end.join
        String.new('PDF:#').concat(code)
      end

      # Render to string.
      # @return [String] Content.
      def render
        @rgb.map do |v|
          format('%<value>.2f', value: v / 255.0)
        end.join(' ')
      end
    end
  end
end
