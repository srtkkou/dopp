# frozen_string_literal: true

require 'dopp/util'
require 'dopp/font'
require 'dopp/document'
require 'dopp/section/type1_font'

module Dopp
  module Font
    # Type1 font "Courier".
    module Courier
      # Font names.
      NAMES ||= ::Dopp::Util.deep_freeze(['Courier'])

      # Update FONTS_CLASSES.
      NAMES.each do |name|
        STORE.add_font_module(name, self)
      end

      module_function

      # Build font section.
      # @param [::Dopp::Document] doc PDF document.
      # @return [::Dopp::Section::Type1Font] Font.
      def build(doc, opts = {})
        font = courier_normal(doc)
        if opts[:bold] && opts[:italic]
          courier_bold_italic(font)
        elsif opts[:italic]
          courier_italic(font)
        elsif opts[:bold]
          courier_bold(font)
        end
        font
      end

      def courier_normal(doc)
        font = ::Dopp::Section::Type1Font.new(doc)
        font.fullname = 'Courier'
        font.encoding = 'StandardEncoding'
        font.names = NAMES
        font
      end

      def courier_bold(font)
        font.fullname = 'Courier-Bold'
        font
      end

      def courier_italic(font)
        font.fullname = 'Courier-Oblique'
        font
      end

      def courier_bold_italic(font)
        font.fullname = 'Courier-BoldOblique'
        font
      end
    end
  end
end
