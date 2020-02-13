# frozen_string_literal: true

require 'dopp/error'
require 'dopp/section/base'
require 'dopp/section/cid_type0_font'
require 'dopp/section/cid_type0_font_dictionary'

module Dopp
  module Section
    # PDF document section "CID type0 font descriptor."
    class CidType0FontDescriptor < Base
      attr_reader :font_dictionary
      attr_reader :font
      attr_reader :document

      # Initialize.
      # @param [::Dopp::Section::CIDType0FontDictionary]
      #   dict Font dictionary section.
      def initialize(dict)
        check_is_a!(dict, ::Dopp::Section::CidType0FontDictionary)
        @font_dictionary = dict
        @font = @font_dictionary.font
        super(@font.document)
        # Initialize attributes.
        attributes[:Type] = :FontDescriptor
        attributes[:FontName] = kw(@font.fullname)
      end

      # Update "Flags".
      # @param [Integer] value Font flags.
      def flags=(value)
        check_is_a!(value, Integer)
        attributes[:Flags] = value
      end

      # Update "FontBBox".
      # @param [Array<Integer>] value Font boundary.
      def b_box=(values)
        check_is_a!(values, Array)
        values.all? do |value|
          check_is_a!(value, Integer)
        end
        attributes[:FontBBox] = list(values)
      end

      # Update "ItalicAngle".
      # @param [Integer] value Font italic angle.
      def italic_angle=(value)
        check_is_a!(value, Integer)
        attributes[:ItalicAngle] = value
      end

      # Update "Ascent".
      # @param [Integer] value Font max height of glyph.
      def ascent=(value)
        check_is_a!(value, Integer)
        attributes[:Ascent] = value
      end

      # Update "Descent".
      # @param [Integer] value Font min height of glyph.
      def descent=(value)
        check_is_a!(value, Integer)
        attributes[:Descent] = value
      end

      # Update "CapHeight".
      # @param [Integer] value Font capital height of glyph.
      def cap_height=(value)
        check_is_a!(value, Integer)
        attributes[:CapHeight] = value
      end

      # Update "StemV".
      # @param [Integer] value Font width.
      def stem_v=(value)
        check_is_a!(value, Integer)
        attributes[:StemV] = value
      end

      # Render to string.
      # @return [String] Content.
      def render
        super
      end
    end
  end
end
