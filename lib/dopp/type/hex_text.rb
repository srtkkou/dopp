# frozen_string_literal: true

require 'dopp/error'

module Dopp
  module Type
    # PDF type "Hexadecimal String".
    class HexText
      include ::Dopp::Error

      class << self
        # New from UTF-8 string.
        # @param [String] string UTF-8 string.
        def new_by_utf8(string)
          bytes = string.encode(
            Encoding::UTF_16BE, Encoding::UTF_8
          ).unpack('C*')
          new(bytes)
        end
      end

      # Initialize.
      # @param [Array<Integer>] bytes Bytes.
      def initialize(bytes)
        check_is_a!(bytes, Array)
        bytes.each do |byte|
          check_is_a!(byte, Integer)
          check_gteq!(byte, 0x0)
          check_lteq!(byte, 0xff)
        end
        bytes << 0x0 if bytes.size.odd?
        @bytes = bytes
      end

      # Convert to String.
      # @return [String] Content.
      def to_s
        joined = @bytes.map do |b|
          format('%<byte>02x', byte: b)
        end.join(' ')
        String.new('PDF:<').concat(joined, '>')
      end

      # Detailed description of this object.
      # @return [String] Description.
      def inspect
        String.new('#<').concat(
          self.class.name, ':',
          object_id.to_s, ' ', to_s, '>'
        )
      end

      # Render to string.
      # @return [String] Content.
      def render
        joined = @bytes.map do |b|
          format('%<byte>02x', byte: b)
        end.join
        String.new('<').concat(joined, '>')
      end
    end
  end
end
