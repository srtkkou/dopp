# frozen_string_literal: true
module Dopp
  module Type
    # PDF type "Literal String".
    class Text
      # Initialize.
      # @param [String] text String.
      def initialize(text)
        raise(ArgumentError) unless text.is_a?(String)
        @string = text
      end

      # Convert to string.
      # @return [String] Content.
      def to_s
        String.new('PDF:"').concat(@string, '"')
      end

      # Detailed description of this object.
      # @return [String] Description.
      def inspect
        String.new('#<').concat(self.class.name, ':',
          self.object_id.to_s, ' ', self.to_s, '>')
      end

      # Render to string.
      # @return [String] Content.
      def render
        String.new('(').concat(@string, ')')
      end
    end
  end
end

