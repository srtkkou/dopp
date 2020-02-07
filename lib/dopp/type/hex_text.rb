# frozen_string_literal: true

module Dopp
  module Type
    # PDF type "Hexadecimal String".
    class HexText
      class << self
        # New from UTF-8 string.
        # @param [String] string UTF-8 string.
        def new_by_utf8(string)
          bytes = string.encode(
            Encoding::UTF_16BE, Encoding::UTF_8
          ).unpack('C*')
          self.new(bytes)
        end
      end

      # Initialize.
      # @param [Array<Integer>] bytes Bytes.
      def initialize(bytes)
        raise(ArgumentError) unless bytes.is_a?(Array)
        raise(ArgumentError) unless
          bytes.all?{ |b| (b >= 0x0) && (b <= 0xff) }
        bytes.append(0x0) if bytes.size.odd?
        @bytes = bytes
      end

      # Convert to String.
      # @return [String] Content.
      def to_s
        joined = @bytes.map{ |b| format('%02x', b) }.join(' ')
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
        joined = @bytes.map{ |b| format('%02x', b) }.join
        String.new('<').concat(joined, '>')
      end
    end
  end
end
