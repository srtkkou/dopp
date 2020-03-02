# frozen_string_literal: true

require 'dopp'
require 'dopp/type'

module Dopp
  class Document
    # Context of the color.
    class ColorContext
      include ::Dopp::Error
      include ::Dopp::Type

      attr_reader :fill_color
      attr_reader :stroke_color

      # Default options.
      DEFAULT_OPTS ||= ::Dopp::Util.deep_freeze(
        fill_color: ::Dopp::COLORS[:Black],
        stroke_color: ::Dopp::COLORS[:Black]
      )

      # Initialize.
      def initialize(opts = {})
        opts = DEFAULT_OPTS.dup.merge(opts)
        DEFAULT_OPTS.keys.each do |key|
          self.__send__("#{key}=", opts[key])
        end
      end

      # Set fill color.
      # @param [String] value Color code.
      def fill_color=(value)
        @fill_color = color(value)
      end

      # Set stroke color.
      # @param [String] value Color code.
      def stroke_color=(value)
        @stroke_color = color(value)
      end
    end
  end
end
