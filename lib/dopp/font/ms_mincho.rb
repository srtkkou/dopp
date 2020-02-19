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
      # Font names.
      NAMES ||= ::Dopp::Util.deep_freeze(
        ['MS明朝', 'MS-Mincho']
      )

      # Add self to font store.
      NAMES.each do |name|
        STORE.add_font_builder(name, self)
      end

      class << self
        # Build font section.
        def build(doc, opts = {})
          ::Dopp::Error::check_is_a!(doc, ::Dopp::Document)
          return bold_italic(doc) if opts[:bold] && opts[:italic]
          return italic(doc) if opts[:italic]
          return bold(doc) if opts[:bold]

          normal(doc)
        end

        private

        def build_base(doc)
          font = ::Dopp::Section::CidType0Font.new(doc)
          font.encoding = 'UniJIS-UCS2-H'
          font.names = NAMES
          # Initialize font dictionary.
          dict = font.new_dictionary
          dict.registry = 'Adobe'
          dict.ordering = 'Japan1'
          dict.supplement = 2
          dict.default_width = 1000
          dict.default_vertical_widths = [880, -1000]
          # Initialize font descriptor.
          desc = dict.new_descriptor
          desc.b_box = [0, -136, 1000, 859]
          desc.italic_angle = 0
          desc.ascent = 859
          desc.descent = -140
          desc.cap_height = 769
          desc.stem_v = 78
          [font, dict, desc]
        end

        def normal(doc)
          font, dict, desc = build_base(doc)
          font.fullname = 'MS-Mincho'
          desc.flags = ::Dopp::Font.flag_value(
            fixed_pitch: true, symbolic: true,
          )
          font
        end

        def bold(doc)
          font, dict, desc = build_base(doc)
          font.fullname = 'MS-Mincho.Bold'
          desc.flags = ::Dopp::Font.flag_value(
            fixed_pitch: true, symbolic: true, force_bold: true
          )
          desc.stem_v = 156
          font
        end

        def italic(doc)
          font, dict, desc = build_base(doc)
          font.fullname = 'MS-Mincho.Italic'
          desc.flags = ::Dopp::Font.flag_value(
            fixed_pitch: true, symbolic: true, italic: true
          )
          desc.italic_angle = -11
          font
        end

        def bold_italic(doc)
          font, dict, desc = build_base(doc)
          font.fullname = 'MS-Mincho.BoldItalic'
          desc.flags = ::Dopp::Font.flag_value(
            fixed_pitch: true, symbolic: true,
            italic: true, force_bold: true
          )
          desc.italic_angle = -11
          desc.stem_v = 156
          font
        end
      end
    end
  end
end
