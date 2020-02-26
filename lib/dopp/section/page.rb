# frozen_string_literal: true

require 'dopp/section/base'
require 'dopp/section/pages'
require 'dopp/section/content'

module Dopp
  module Section
    # PDF document section "page".
    class Page < Base
      include ::Dopp::Error

      attr_reader :media_width
      attr_reader :media_height
      attr_reader :content

      # Initialize.
      # @param [::Dopp::Section::Pages] pages PDF pages.
      def initialize(pages, opts = {})
        check_is_a!(pages, ::Dopp::Section::Pages)
        @parent = pages
        super(pages.structure)
        # Initialize attributes.
        @attributes[:Type] = :Page
        @attributes[:Parent] = @parent.ref
        self.rotate = 0
        attributes[:Resources] = dict({})
        doc_size = opts[:page_size] || :A4
        media_box_by_size(doc_size, opts[:landscape])
        # Initialize instance variables.
        @content = ::Dopp::Section::Content.new(self)
        attributes[kw(:Contents)] = list([@content.ref])
      end

      # Set page rotation angle.
      # @param [Integer] value Angle.
      def rotate=(value)
        check_include!(value, ::Dopp::ROTATE_ANGLES)
        @attributes[:Rotate] = value
      end

      # Add font in resources.
      # @param [::Dopp::Section::Base] font Font section.
      def add_font(font)
        key = kw(font.alias)
        @attributes[:Resources][:Font] ||= dict({})
        @attributes[:Resources][:Font][key] = font.ref
      end

      # Render to string.
      # @return [String] Content.
      def render
        super
      end

      private

      # Calculate media box by document size.
      # @param [Symbol] name Document size name.
      # @param [Bool] landscape Landscape flag.
      def media_box_by_size(name, landscape = false)
        check_include!(name, ::Dopp::PAGE_SIZES.keys)
        mm_x, mm_y = ::Dopp::PAGE_SIZES[name]
        # Swap x, y when landscape is true.
        mm_x, mm_y = mm_y, mm_x if landscape
        @media_width = ::Dopp::Util.mm_to_pt(mm_x)
        @media_height = ::Dopp::Util.mm_to_pt(mm_y)
        box = [0.0, 0.0, @media_width, @media_height]
        @attributes[:MediaBox] = list(box)
      end
    end
  end
end
