# frozen_string_literal: true

require 'dopp/error'

module Dopp
  module Type
    # PDF type "Literal String".
    class Text
      include ::Dopp::Error

      # Initialize.
      # @param [String] text String.
      def initialize(text)
        check_is_a!(text, String)
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
        String.new('#<').concat(
          self.class.name, ':',
          object_id.to_s, ' ', to_s, '>'
        )
      end

      # Render to string.
      # @return [String] Content.
      def render
        String.new('(').concat(@string, ')')
      end
    end
  end
end
