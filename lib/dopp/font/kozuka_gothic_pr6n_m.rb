# frozen_string_literal: true

require 'dopp/util'
require 'dopp/font'
require 'dopp/document'
require 'dopp/section/cid_type0_font'

module Dopp
  module Font
    # CID font "Kozuka Gothic Pr6N Medium".
    module KozukaGothicPr6nM
      # Font names.
      NAMES ||= ::Dopp::Util.deep_freeze([
        '小塚ゴシックPr6N-M', 'KozukaGothicPr6nM',
        '小塚ｺﾞｼｯｸPr6N-M'
      ])

      # Update FONT_CLASSES.
      NAMES.each do |name|
        key = name.downcase.tr('-_ ', '')
        ::Dopp::Font::FONT_MODULES[key] = self
      end

      module_function

      # Build font section.
      # @param [::Dopp::Document] doc PDF document.
      # @return [::Dopp::Section::CidType0Font] Font.
      def build(doc, opts = {})
        # Initialize font.
        font = ::Dopp::Section::CidType0Font.new(doc)
        font.fullname = 'KozGoPr6N-Medium'
        font.encoding = 'UniJIS-UCS2-H'
        font.names = NAMES
        # Initialize font dictionary.
        dict = font.new_dictionary
        dict.registry = 'Adobe'
        dict.ordering = 'Japan1'
        dict.supplement = 6
        # Initialize font descriptor.
        desc = dict.new_descriptor
        desc.flags = 4
        desc.b_box = [-538, -374, 1254, 1418]
        desc.italic_angle = 0
        desc.ascent = 1418
        desc.descent = -374
        desc.cap_height = 763
        desc.stem_v = 116
        font
      end
    end
  end
end
