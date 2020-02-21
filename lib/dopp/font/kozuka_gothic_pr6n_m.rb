# frozen_string_literal: true

require 'dopp'
require 'dopp/section/cid_type0_font'

module Dopp
  module Font
    # CID font "Kozuka Gothic Pr6N Medium".
    class KozukaGothicPr6nM
      include ::Dopp::Error
      include ::Dopp::Font

      # Font names.
      NAMES ||= %w[
        ゴシック 小塚ゴシック 小塚ゴシックPr6N-M
        Gothic KozukaGothic KozukaGothicPr6nM
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
      end

      # Build font section.
      # @return [::Dopp::Section::CidType0Font] Font.
      def build
        build_common
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
        @desc.flags = 4
        @desc.b_box = [-538, -374, 1254, 1418]
        @desc.italic_angle = 0
        @desc.ascent = 1418
        @desc.descent = -374
        @desc.cap_height = 763
        @desc.stem_v = 116
      end

      # Build normal font.
      # @return [::Dopp::Section::CidType0Font] Font.
      def normal
        @font.fullname = 'KozGoPr6N-Medium'
        @font
      end
    end
  end
end
