# frozen_string_literal: true

require 'dopp/util'

module Dopp
  module Section
    # PDF document section "header".
    class Header
      # Default PDF version.
      DEFAULT_PDF_VERSION ||= '1.3'

      # Document identifier.
      PDF_IDENTIFIER ||= ::Dopp::Util.deep_freeze(
        [0xE2, 0xE3, 0xCF, 0xD3].pack('c*'))

      attr_reader :version

      # Initialize.
      # @param [::Dopp::Document] doc PDF document.
      # @param [String] version PDF version.
      def initialize(version = DEFAULT_PDF_VERSION)
        raise(ArgumentError) unless version.is_a?(String)
        # Set variables.
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
