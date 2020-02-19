# frozen_string_literal: true

require 'dopp/error'

module Dopp
  module Shape
    class Color
      include ::Dopp::Error

      # CSS color code format.
      CODE_FORMAT ||=
        /\A#?(?<r>\h{2})(?<g>\h{2})(?<b>\h{2})\z/.freeze

      # Initialize color.
      def initialize(code)
        check_matches!(code, CODE_FORMAT)
        @red, @green, @blue = CODE_FORMAT.match(code)
          .to_a.values_at(1, 2, 3).map { |s| s.to_i(16) }
      end

      # Render to string.
      # @return [String] Rendered string.
      def render
        [@red, @green, @blue].map do |v|
          format('%<value>.2f', value: v / 255.0)
        end.join(' ')
      end
    end
  end
end
