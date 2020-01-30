# frozen_string_literal: true

module Dopp
  module Section
    class Header
      # Initialize.
      # @params version [String] PDF version
      def initialize(version = '1.2')
        @version = version
      end

      # Render to string.
      # @return [String] header string
      def to_s
        "%PDF-#{@version}%" +
          [0xE2, 0xE3, 0xCF, 0xD3].pack('c*')
      end
    end
  end
end

