# frozen_string_literal: true

require 'dopp/util'

module Dopp
  module Section
    # PDF document section "header".
    class Header
      # Document identifier.
      DOCUMENT_IDENTIFIER ||= ::Dopp::Util.deep_freeze(
        [0xE2, 0xE3, 0xCF, 0xD3].pack('c*'))

      attr_reader :version

      # Initialize.
      # @params [String] version PDF version
      def initialize(version = '1.2')
        raise(ArgumentError) unless version.is_a?(String)
        @version = version
      end

      # Render to string.
      # @return [String] Rendered string.
      def render
        String.new('%PDF-').concat(@version, LF,
          '%', DOCUMENT_IDENTIFIER, LF)
      end
    end
  end
end

