# frozen_string_literal: true

require 'forwardable'
require 'dopp/document/color_context'
require 'dopp/document/page_context'

module Dopp
  class Document
    # Context of the document.
    class Context
      extend Forwardable

      def_delegators(
        :@page_context,
        :page_size=, :landscape=, :rotate=,
        :page_size, :landscape, :rotate,
        :media_box, :page_width, :page_height,
        :x, :y
      )
      def_delegators(
        :@color_context,
        :fill_color=, :stroke_color=,
        :fill_color, :stroke_color
      )

      # Initialize.
      def initialize(opts = {})
        @page_context = PageContext.new(self, opts)
        @color_context = ColorContext.new(self, opts)
      end

      # Update values by hash.
      # @param [Hash] opts Options.
      def update(opts)
        @page_context.update(opts)
        @color_context.update(opts)
      end

      # Convert to string.
      # @return [String] Content.
      def to_s
        attrs = %i[
          page_size landscape rotate x y
          fill_color stroke_color
        ]
        attrs.map do |attr|
          attr.to_s.concat('=', __send__(attr).to_s)
        end.join(', ')
      end

      # Detailed description of this object.
      # @return [String] Description.
      def inspect
        String.new('#<').concat(
          self.class.name, ':',
          object_id.to_s, ' ', to_s, '>'
        )
      end
    end
  end
end
