# frozen_string_literal: true

require 'dopp/const'
require 'dopp/error'
require 'dopp/type'
require 'dopp/util'

module Dopp
  class Document
    # Context of the page.
    class PageContext
      include ::Dopp::Error
      include ::Dopp::Type
      include ::Dopp::Util

      attr_reader :context
      attr_reader :page_size
      attr_reader :landscape
      attr_reader :rotate
      attr_reader :page_width
      attr_reader :page_height
      attr_reader :media_box
      attr_accessor :padding_top
      attr_accessor :padding_bottom
      attr_accessor :padding_left
      attr_accessor :padding_right
      attr_accessor :mm_x
      attr_accessor :mm_y

      # Default options.
      DEFAULT_OPTS ||= ::Dopp::Util.deep_freeze(
        page_size: :A4, landscape: false, rotate: 0,
        padding_top: 10, padding_bottom: 10,
        padding_left: 10, padding_right: 10,
        mm_x: 0, mm_y: 0
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

      # Set page size. Calculate page width and height.
      # @param [Symbol] value Page size.
      def page_size=(value)
        check_include!(value, ::Dopp::PAGE_SIZES.keys)
        @page_size = value
        update_media_box
      end

      # Set page shape: portrait or landscape.
      # @param [Bool] value True=landscape, false=portrait.
      def landscape=(value)
        check_include!(value, [true, false])
        @landscape = value
        update_media_box
      end

      # Set page rotation angle.
      # @param [Integer] value Angle.
      def rotate=(value)
        check_include!(value, ::Dopp::ROTATE_ANGLES)
        @rotate = value
      end

      # Get width of the canvas.
      # @return [Float] Canvas width.
      def canvas_width
        @page_width - mm_to_pt(@padding_left + @padding_right)
      end

      # Get height of the canvas.
      # @return [Float] Canvas height.
      def canvas_height
        @page_height - mm_to_pt(@padding_top + @padding_bottom)
      end

      # Get X position in pt.
      # @return [Float] X position.
      def x
        mm_to_pt(@padding_left + @mm_x)
      end

      # Get Y position in pt.
      # @return [Float] Y position.
      def y
        @page_height - mm_to_pt(@padding_top + @mm_y)
      end

      private

      # Update media box by page size and landscape.
      def update_media_box
        box = ::Dopp::PAGE_SIZES[@page_size].dup.map do |mm|
          mm_to_pt(mm)
        end
        box[0], box[1] = box[1], box[0] if @landscape
        @page_width, @page_height = box[0], box[1]
        @media_box = list([0.0, 0.0] + box)
      end
    end
  end
end
