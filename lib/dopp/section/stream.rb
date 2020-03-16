# frozen_string_literal: true

require 'zlib'
require 'dopp/const'
require 'dopp/error'

module Dopp
  module Section
    # PDF document stream.
    class Stream
      include ::Dopp::Error

      attr_reader :flate_decode

      # Initialize.
      def initialize
        @lines = []
      end

      # Add line to stream.
      def <<(line)
        check_is_a!(line, String)
        @lines << line
      end

      # Set compression flag.
      # @param [Bool] value
      #   True=compress, false=no compress.
      def flate_decode=(value)
        check_include!(value, [true, false])
        @flate_decode = value
      end

      # Render to string.
      # @return [String] Content.
      def render
        return '' if @lines.empty?

        buffer = @lines.join(LF)
        buffer = zlib_compress(buffer) if @flate_decode
        String.new(LF).concat(buffer, LF)
      end

      private

      # Compress the string in buffer.
      # @return [String] Compressed byte string.
      def zlib_compress(buffer)
        return '' if buffer.empty?

        Zlib::Deflate.deflate(buffer, Zlib::BEST_COMPRESSION)
      end
    end
  end
end
