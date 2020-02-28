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

      # Default optsions.
      DEFAULT_OPTS ||= ::Dopp::Util.deep_freeze(
        pdf_version: ::Dopp::DEFAULT_PDF_VERSION
      )

      attr_reader :pdf_version

      # Initialize.
      # @param [String] version PDF version.
      def initialize(opts = {})
        opts = DEFAULT_OPTS.dup.merge(opts)
        self.pdf_version = opts[:pdf_version]
      end

      # Set PDF version.
      # @param [String] value PDF version.
      def pdf_version=(value)
        check_matches!(value, /\A1\.\d+\z/)
        @pdf_version = value
      end

      # Render to string.
      # @return [String] Rendered string.
      def render
        String.new('%PDF-').concat(
          @pdf_version, LF, '%', PDF_IDENTIFIER, LF
        )
      end
    end
  end
end
