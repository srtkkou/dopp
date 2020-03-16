# frozen_string_literal: true

require 'dopp/const'
require 'dopp/error'
require 'dopp/type'
require 'dopp/util'

module Dopp
  class Document
    # Context of the color.
    class ColorContext
      include ::Dopp::Error
      include ::Dopp::Type

      attr_reader :context
      attr_reader :fill_color
      attr_reader :stroke_color

      # Default options.
      DEFAULT_OPTS ||= ::Dopp::Util.deep_freeze(
        fill_color: ::Dopp::COLORS[:Black],
        stroke_color: ::Dopp::COLORS[:Black]
      )

      # Initialize.
      # @param [::Dopp::Document::Context] context Context.
      def initialize(context, opts = {})
        check_is_a!(context, ::Dopp::Document::Context)
        @context = context
        update(DEFAULT_OPTS.dup.merge(opts))
      end

      # Update values by hash.
      # @param [Hash] opts Options.
      def update(opts)
        DEFAULT_OPTS.keys.each do |key|
          value = opts[key]
          __send__("#{key}=", value) unless value.nil?
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
