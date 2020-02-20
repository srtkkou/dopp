# frozen_string_literal: true

require 'dopp/util'
require 'dopp/section/base'
require 'dopp/section/pages'
require 'dopp/section/content'

module Dopp
  module Section
    # PDF document section "page".
    class Page < Base
      include ::Dopp::Util

      # Document sizes (width * height in millimeters).
      MEDIA_SIZES ||= {
        A1: [594.0, 841.0], A2: [420.0, 584.0], A3: [297.0, 420.0],
        A4: [210.0, 297.0], A5: [148.0, 210.0], A6: [105.0, 148.0],
        B1: [728.0, 1030.0], B2: [515.0, 728.0], B3: [364.0, 515.0],
        B4: [257.0, 364.0], B5: [182.0, 257.0], B6: [128.0, 182.0],
        Letter: [215.9, 279.4]
      }.tap { |v| ::Dopp::Util.deep_freeze(v) }

      attr_reader :media_width
      attr_reader :media_height
      attr_reader :content

      # Initialize.
      # @param [::Dopp::Section::Pages] pages PDF pages.
      def initialize(pages, attrs = {})
        check_is_a!(pages, ::Dopp::Section::Pages)
        @parent = pages
        super(pages.document)
        # Initialize attributes.
        attributes[:Type] = :Page
        attributes[:Parent] = @parent.ref
        attributes[:Rotate] = 0
        attributes[:Resources] = dict({})
        doc_size = attrs[:size] || :A4
        media_box_by_size(doc_size, attrs[:landscape])
        # Initialize instance variables.
        @content = ::Dopp::Section::Content.new(self)
        attributes[kw(:Contents)] = list(
          [@content].map(&:ref)
        )
      end

      # Add font in resources.
      # @param [::Dopp::Section::Base] font Font section.
      def add_font(font)
        key = kw(font.alias)
        attributes[:Resources][:Font] ||= dict({})
        attributes[:Resources][:Font][key] = font.ref
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
        check_include!(name, MEDIA_SIZES.keys)
        mm_x, mm_y = MEDIA_SIZES[name]
        # Swap x, y when landscape is true.
        mm_x, mm_y = mm_y, mm_x if landscape
        @media_width = mm_to_pt(mm_x)
        @media_height = mm_to_pt(mm_y)
        box = [0.0, 0.0, @media_width, @media_height]
        attributes[:MediaBox] = list(box)
      end
    end
  end
end
