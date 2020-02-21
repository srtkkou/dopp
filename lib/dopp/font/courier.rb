# frozen_string_literal: true

require 'dopp'
require 'dopp/section/type1_font'

module Dopp
  module Font
    # Type1 font "Courier".
    class Courier
      include ::Dopp::Error

      # Font names.
      NAMES ||= %w[
        Courier
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
        @font = ::Dopp::Section::Type1Font.new(structure)
      end

      # Build font section.
      # @return [::Dopp::Section::Type1Font] Font section.
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
        @font.encoding = 'StandardEncoding'
        @font.names = NAMES
      end

      # Build normal font.
      # @return [::Dopp::Section::Type1Font] Font section.
      def normal
        @font.fullname = 'Courier'
        @font
      end

      # Build bold font.
      # @return [::Dopp::Section::Type1Font] Font section.
      def bold
        @font.fullname = 'Courier-Bold'
        @font
      end

      # Build italic font.
      # @return [::Dopp::Section::Type1Font] Font section.
      def italic
        @font.fullname = 'Courier-Oblique'
        @font
      end

      # Build bold italic font.
      # @return [::Dopp::Section::Type1Font] Font section.
      def bold_italic
        @font.fullname = 'Courier-BoldOblique'
        @font
      end
    end
  end
end
