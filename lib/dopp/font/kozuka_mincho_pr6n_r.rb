# frozen_string_literal: true

require 'dopp/util'
require 'dopp/font'
require 'dopp/document'
require 'dopp/section/cid_type0_font'

module Dopp
  module Font
    # CID font "Kozuka Mincho Pr6N Regular".
    module KozukaMinchoPr6nR
      # Font names.
      NAMES ||= ::Dopp::Util.deep_freeze([
        '小塚明朝Pr6N-R', 'KozukaMinchoPr6nR'
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
        font.fullname = 'KozMinPr6N-Regular'
        font.encoding = 'UniJIS-UCS2-H'
        font.names = NAMES
        # Initialize font dictionary.
        dict = font.new_dictionary
        dict.registry = 'Adobe'
        dict.ordering = 'Japan1'
        dict.supplement = 6
        # Initialize font descriptor.
        desc = dict.new_descriptor
        desc.flags = 6
        desc.b_box = [-437, -340, 1147, 1317]
        desc.italic_angle = 0
        desc.ascent = 1317
        desc.descent = -340
        desc.cap_height = 742
        desc.stem_v = 80
        font
      end
    end
  end
end
