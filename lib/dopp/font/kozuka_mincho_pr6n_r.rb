# frozen_string_literal: true

require 'dopp/error'
require 'dopp/util'
require 'dopp/font'
require 'dopp/document'
require 'dopp/section/cid_type0_font'

module Dopp
  module Font
    # CID font "Kozuka Mincho Pr6N Regular".
    class KozukaMinchoPr6nR
      # Font names.
      NAMES ||= ::Dopp::Util.deep_freeze(
        [
          '明朝', '小塚明朝Pr6N-R', 'KozukaMinchoPr6nR'
        ]
      )

      # Add self to font store.
      NAMES.each do |name|
        STORE.add_font_builder(name, self)
      end

      class << self
        # Build font section.
        # @param [::Dopp::Document] doc PDF document.
        # @return [::Dopp::Section::CidType0Font] Font.
        def build(doc, opts = {})
          ::Dopp::Error::check_is_a!(doc, ::Dopp::Document)
          return bold_italic(doc) if opts[:bold] && opts[:italic]
          return italic(doc) if opts[:italic]
          return bold(doc) if opts[:bold]

          normal
        end

        private

        # Build base for this font.
        # @param [::Dopp::Document] doc Document.
        # @return [Array] Font elements.
        def build_base(doc)
          font = ::Dopp::Section::CidType0Font.new(doc)
          font.encoding = 'UniJIS-UCS2-H'
          font.names = NAMES
          # Initialize font dictionary.
          dict = font.new_dictionary
          dict.registry = 'Adobe'
          dict.ordering = 'Japan1'
          dict.supplement = 6
          # Initialize font descriptor.
          desc = dict.new_descriptor
          desc.b_box = [-437, -340, 1147, 1317]
          desc.italic_angle = 0
          desc.ascent = 1317
          desc.descent = -340
          desc.cap_height = 742
          desc.stem_v = 80
          [font, dict, desc]
        end

        # Build normal font.
        # @param [::Dopp::Document] doc Document.
        # @return [::Dopp::Section::CidType0Font] Font section.
        def normal(doc)
          font, dict, desc = build_base(doc)
          font.fullname = 'KozMinPr6N-Regular'
          flag_opts = {serif: true, symbolic: true}
          desc.flags = ::Dopp::Font.flag_value(
            serif: true, symbolic: true
          )
          font
        end

        # Build bold font.
        # @param [::Dopp::Document] doc Document.
        # @return [::Dopp::Section::CidType0Font] Font section.
        def bold(doc)
          font, dict, desc = build_base(doc)
          font.fullname = 'KozMinPr6N-Regular.Bold'
          desc.flags = ::Dopp::Font.flag_value(
            serif: true, symbolic: true, force_bold: true
          )
          desc.stem_v = 160
          font
        end

        # Build italic font.
        # @param [::Dopp::Document] doc Document.
        # @return [::Dopp::Section::CidType0Font] Font section.
        def italic(doc)
          font, dict, desc = build_base(doc)
          font.fullname = 'KozMinPr6N-Regular.Italic'
          desc.flags = ::Dopp::Font.flag_value(
            serif: true, symbolic: true, italic: true
          )
          desc.italic_angle = -11
          font
        end

        # Build bold italic font.
        # @param [::Dopp::Document] doc Document.
        # @return [::Dopp::Section::CidType0Font] Font section.
        def bold_italic(doc)
          font, dict, desc = build_base(doc)
          font.fullname = 'KozMinPr6N-Regular.BoldItalic'
          desc.flags = ::Dopp::Font.flag_value(
            serif: true, symbolic: true,
            italic: true, force_bold: true
          )
          desc.italic_angle = -11
          desc.stem_v = 160
          font
        end
      end
    end
  end
end
