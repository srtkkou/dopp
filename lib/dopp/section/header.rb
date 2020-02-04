# frozen_string_literal: true

require 'dopp/util'

module Dopp
  module Section
    # PDF document section "header".
    class Header
      # Document identifier.
      PDF_IDENTIFIER ||= ::Dopp::Util.deep_freeze(
        [0xE2, 0xE3, 0xCF, 0xD3].pack('c*'))

      attr_reader :version

      # Initialize.
      # @param [::Dopp::Document] doc PDF document.
      # @param [String] version PDF version.
      def initialize(doc, version = '1.2')
        raise(ArcumentError) unless doc.is_a?(::Dopp::Document)
        raise(ArgumentError) unless version.is_a?(String)
        # Set variables.
        @document = doc
        @version = version
      end

      # Render to string.
      # @return [String] Rendered string.
      def render
        String.new('%PDF-').concat(
          @version, LF, '%', PDF_IDENTIFIER, LF)
      end
    end
  end
end
