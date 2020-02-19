# frozen_string_literal: true

require 'dopp/error'
require 'dopp/util'
require 'dopp/font'
require 'dopp/document'
require 'dopp/section/type1_font'

module Dopp
  module Font
    # Type1 font "Courier".
    class Courier
      # Font names.
      NAMES ||= ::Dopp::Util.deep_freeze(['Courier'])

      # Add self to font store.
      NAMES.each do |name|
        STORE.add_font_builder(name, self)
      end

      class << self

        # Build font section.
        # @param [::Dopp::Document] doc PDF document.
        # @return [::Dopp::Section::Type1Font] Font.
        def build(doc, opts = {})
          ::Dopp::Error.check_is_a!(doc, ::Dopp::Document)
          return bold_italic(doc) if opts[:bold] && opts[:italic]
          return italic(doc) if opts[:italic]
          return bold(doc) if opts[:bold]

          normal(doc)
        end

        private

        def build_base(doc)
          font = ::Dopp::Section::Type1Font.new(doc)
          font.encoding = 'StandardEncoding'
          font.names = NAMES
          font
        end

        def normal(doc)
          font = build_base(doc)
          font.fullname = 'Courier'
          font
        end

        def bold(doc)
          font = build_base(doc)
          font.fullname = 'Courier-Bold'
          font
        end

        def italic(font)
          font = build_base(doc)
          font.fullname = 'Courier-Oblique'
          font
        end

        def bold_italic(font)
          font = build_base(doc)
          font.fullname = 'Courier-BoldOblique'
          font
        end
      end
    end
  end
end
