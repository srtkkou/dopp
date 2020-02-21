# frozen_string_literal: true

require 'dopp'
require 'dopp/section/cid_type0_font'

module Dopp
  module Font
    # CID font "Kozuka Mincho Pr6N Regular".
    class KozukaMinchoPr6nR
      include ::Dopp::Error
      include ::Dopp::Font

      # Font names.
      NAMES ||= %w[
        明朝 小塚明朝 小塚明朝Pr6N-R
        Mincho KozukaMincho KozukaMinchoPr6nR
      ].tap { |v| ::Dopp::Util.deep_freeze(v) }

      # Add self to font store.
      NAMES.each do |name|
        STORE.add_font_builder(name, self)
      end

      # Initialize.
      # @param [::Dopp::Document::Structure]
      #   structure PDF document structure.
      def initialize(structure, opts = {})
        check_is_a!(structure, ::Dopp::Document::Structure)
        @opts = opts
        @font = ::Dopp::Section::CidType0Font.new(structure)
        @dict = @font.new_dictionary
        @desc = @dict.new_descriptor
        @desc_flags = { serif: true, symbolic: true }
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
        @dict.supplement = 6
        # Initialize font descriptor.
        @desc.b_box = [-437, -340, 1147, 1317]
        @desc.italic_angle = 0
        @desc.ascent = 1317
        @desc.descent = -340
        @desc.cap_height = 742
        @desc.stem_v = 80
      end

      # Build normal font.
      # @return [::Dopp::Section::CidType0Font] Font section.
      def normal
        @font.fullname = 'KozMinPr6N-Regular'
        @desc.flags = flag_value(@desc_flags)
        @font
      end

      # Build bold font.
      # @return [::Dopp::Section::CidType0Font] Font section.
      def bold
        @font.fullname = 'KozMinPr6N-Regular.Bold'
        @desc.flags = flag_value(
          @desc_flags.merge(force_bold: true)
        )
        @desc.stem_v = 160
        @font
      end

      # Build italic font.
      # @return [::Dopp::Section::CidType0Font] Font section.
      def italic
        @font.fullname = 'KozMinPr6N-Regular.Italic'
        @desc.flags = flag_value(
          @desc_flags.merge(italic: true)
        )
        @desc.italic_angle = -11
        @font
      end

      # Build bold italic font.
      # @return [::Dopp::Section::CidType0Font] Font section.
      def bold_italic
        @font.fullname = 'KozMinPr6N-Regular.BoldItalic'
        @desc.flags = flag_value(
          @desc_flags.merge(italic: true, force_bold: true)
        )
        @desc.italic_angle = -11
        @desc.stem_v = 160
        @font
      end
    end
  end
end
