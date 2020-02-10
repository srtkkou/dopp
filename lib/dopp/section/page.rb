# frozen_string_literal: true

require 'dopp/util'
require 'dopp/section/base'
require 'dopp/section/pages'
require 'dopp/section/content'

module Dopp
  module Section
    # PDF document section "page".
    class Page < Base

      # Document sizes (width * height in millimeters).
      DOCUMENT_SIZES ||= ::Dopp::Util.deep_freeze({
        A1: [594.0, 841.0], A2: [420.0, 584.0], A3: [297.0, 420.0],
        A4: [210.0, 297.0], A5: [148.0, 210.0], A6: [105.0, 148.0],
        B1: [728.0, 1030.0], B2: [515.0, 728.0], B3: [364.0, 515.0],
        B4: [257.0, 364.0], B5: [182.0, 257.0], B6: [128.0, 182.0],
        Letter: [215.9, 279.4]
      })

      attr_reader :content

      # Initialize.
      # @param [::Dopp::Section::Pages] pages PDF pages.
      def initialize(pages, attrs = {})
        check_is_a!(pages, ::Dopp::Section::Pages)
        @parent = pages
        super(pages.document)
        # Initialize attributes.
        attributes[kw(:Type)] = kw(:Page)
        attributes[kw(:Parent)] = @parent.ref
        doc_size = attrs[:size] || :A4
        attributes[kw(:MediaBox)] =
          media_box_by_size(doc_size, attrs)
        attributes[kw(:Rotate)] = 0
        attributes[kw(:Resources)] = dict({})
        # Initialize instance variables.
        @content = ::Dopp::Section::Content.new(self)
        attributes[kw(:Contents)] = list(
          [@content].map(&:ref)
        )
      end

      # Set font in resources.
      # @param [::Dopp::Section::Base] font Font section.
      def set_font(font)
        attributes[kw(:Resources)][kw(:Font)] ||= dict({})
        attributes[kw(:Resources)][kw(:Font)][kw(font.alias)] = font.ref
      end

      # Render to string.
      # @return [String] Content.
      def render
        super
      end

      private

      # Calculate media box by document size.
      # @param [Symbol] name Document size name.
      # @param [Hash] opts Document size options.
      def media_box_by_size(name, opts = {})
        check_include!(name, DOCUMENT_SIZES.keys)
        mm_width, mm_height = DOCUMENT_SIZES[name]
        if opts[:landscape]
          rect = [0.0, 0.0, mm_height, mm_width]
        else
          rect = [0.0, 0.0, mm_width, mm_height]
        end
        list(rect.map{ |mm| ::Dopp::Util.mm_to_pt(mm) })
      end
    end
  end
end
