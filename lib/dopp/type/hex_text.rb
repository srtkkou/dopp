# frozen_string_literal: true
module Dopp
  module Type
    class HexText
      # Initialize
      # @param text [String] text
      def initialize(text)
        raise(ArgumentError) unless text.is_a?(String)
        @original = text
        # Convert UTF-8 string to UTF-16BE.
        bytes = text.encode(
          Encoding::UTF_16BE, Encoding::UTF_8
        ).unpack('C*')
        bytes.append(0) if (bytes.size % 2 != 0)
        @content = ('<' +
          bytes.map{|b| '%02X' % b}.join +
        '>').freeze
      end

      # Render to String.
      # @return [String] Content.
      def to_s
        @content
      end

      # TODO: Show encoded byte string.
      #def inspect
      #end

      # TODO: Parse.
      #def self.parse(text)
      #end
    end
  end
end
