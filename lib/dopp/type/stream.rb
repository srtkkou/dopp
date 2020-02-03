# frozen_string_literal: true
module Dopp
  module Type
    class Stream

      HEADER ||= 'stream'.freeze

      FOOTER ||= 'endstream'.freeze

      # Initialize.
      def initialize
        @stream = []
      end

      # Add content.
      def <<(text)
        raise ArgumentError unless text.instance_of?(String)
        @stream << text
      end

      # Length of the content.
      def length
        self.render.size
      end

      # Convert content to string.
      def render
        [HEADER, @stream, FOOTER].flatten.join(LF)
      end
    end
  end
end
