# frozen_string_literal: true

require 'dopp'
require 'dopp/type'

module Dopp
  class Document
    # Context of the page.
    class PageContext
      include ::Dopp::Error
      include ::Dopp::Type

      attr_reader :page_size
      attr_reader :landscape
      attr_reader :rotate
      attr_reader :page_width
      attr_reader :page_height

      # Default options.
      DEFAULT_OPTS ||= ::Dopp::Util.deep_freeze(
        page_size: :A4, landscape: false, rotate: 0
      )

      # Initialize.
      def initialize(opts = {})
        opts = DEFAULT_OPTS.dup.merge(opts)
        DEFAULT_OPTS.keys.each do |key|
          self.__send__("#{key}=", opts[key])
        end
      end

      # Set page size. Calculate page width and height.
      # @param [Symbol] value Page size.
      def page_size=(value)
        check_include!(value, ::Dopp::PAGE_SIZES.keys)
        @page_size = value
        mm_x, mm_y = ::Dopp::PAGE_SIZES[@page_size]
        @page_width = ::Dopp::Util.mm_to_pt(mm_x)
        @page_height = ::Dopp::Util.mm_to_pt(mm_y)
      end

      # Set page shape: portrait or landscape.
      # @param [Bool] value True=landscape, false=portrait.
      def landscape=(value)
        check_include!(value, [true, false])
        @landscape = value
        return unless @landscape
        return if @page_width > @page_height

        @page_width, @page_height = @page_height, @page_width
      end

      # Set page rotation angle.
      # @param [Integer] value Angle.
      def rotate=(value)
        check_include!(value, ::Dopp::ROTATE_ANGLES)
        @rotate = value
      end

      # Get media box parameter.
      # @return [::Dopp::Type::List<Float>] Media box.
      def media_box
        list([0.0, 0.0, @page_width, @page_height])
      end
    end
  end
end
