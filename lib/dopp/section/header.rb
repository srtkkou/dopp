# frozen_string_literal: true

require 'dopp'

module Dopp
  module Section
    # PDF document section "header".
    class Header
      include ::Dopp::Error

      # Document identifier.
      PDF_IDENTIFIER ||= ::Dopp::Util.deep_freeze(
        [0xE2, 0xE3, 0xCF, 0xD3].pack('c*')
      )

      attr_reader :version

      # Initialize.
      # @param [String] version PDF version.
      def initialize(version = DEFAULT_PDF_VERSION)
        check_matches!(version, /\A1\.\d+\z/)
        @version = version
      end

      # Render to string.
      # @return [String] Rendered string.
      def render
        String.new('%PDF-').concat(
          @version, LF, '%', PDF_IDENTIFIER, LF
        )
      end
    end
  end
end
