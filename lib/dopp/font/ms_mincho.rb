# frozen_string_literal: true

require 'dopp/error'
require 'dopp/util'
require 'dopp/font'
require 'dopp/document'
require 'dopp/section/cid_type0_font'

module Dopp
  module Font
    # CID font "MS Mincho".
    class MsMincho
      include ::Dopp::Font

      # Font names.
      NAMES ||= %w[
        MS明朝 MS-Mincho
      ].tap { |v| ::Dopp::Util.deep_freeze(v) }

      # Add self to font store.
      NAMES.each do |name|
        STORE.add_font_builder(name, self)
      end

      # Initialize.
      # @param [::Dopp::Document] doc PDF document.
      def initialize(doc, opts = {})
        ::Dopp::Error.check_is_a!(doc, ::Dopp::Document)
        @document = doc
        @opts = opts
        @font = ::Dopp::Section::CidType0Font.new(doc)
        @dict = @font.new_dictionary
        @desc = @dict.new_descriptor
        @desc_flags = { fixed_pitch: true, symbolic: true }
      end

      # Build font section.
      # @return [::Dopp::Section::CidType0Font] Font section.
      def build
        build_common
        return bold_italic if @opts[:bold] && @opts[:italic]
        return italic if @opts[:italic]
        return bold if @opts[:bold]

        normal
      end

      private

      # Build common part of this font.
      def build_common
        @font.encoding = 'UniJIS-UCS2-H'
        @font.names = NAMES
        # Initialize font dictionary.
        @dict.registry = 'Adobe'
        @dict.ordering = 'Japan1'
        @dict.supplement = 2
        @dict.default_width = 1000
        @dict.default_vertical_widths = [880, -1000]
        # Initialize font descriptor.
        @desc.b_box = [0, -136, 1000, 859]
        @desc.italic_angle = 0
        @desc.ascent = 859
        @desc.descent = -140
        @desc.cap_height = 769
        @desc.stem_v = 78
      end

      # Build normal font.
      # @return [::Dopp::Section::CidType0Font] Font section.
      def normal
        @font.fullname = 'MS-Mincho'
        @desc.flags = flag_value(@desc_flags)
        @font
      end

      # Build bold font.
      # @return [::Dopp::Section::CidType0Font] Font section.
      def bold
        @font.fullname = 'MS-Mincho.Bold'
        @desc.flags = flag_value(
          @desc_flags.merge(force_bold: true)
        )
        @desc.stem_v = 156
        @font
      end

      # Build italic font.
      # @return [::Dopp::Section::CidType0Font] Font section.
      def italic
        @font.fullname = 'MS-Mincho.Italic'
        @desc.flags = flag_value(
          @desc_flags.merge(italic: true)
        )
        @desc.italic_angle = -11
        @font
      end

      # Build bold italic font.
      # @return [::Dopp::Section::CidType0Font] Font section.
      def bold_italic
        @font.fullname = 'MS-Mincho.BoldItalic'
        @desc.flags = flag_value(
          @desc_flags.merge(italic: true, force_bold: true)
        )
        @desc.italic_angle = -11
        @desc.stem_v = 156
        @font
      end
    end
  end
end