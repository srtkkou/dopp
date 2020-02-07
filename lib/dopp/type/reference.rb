# frozen_string_literal: true

module Dopp
  module Type
    # PDF type "Reference".
    class Reference
      # Initialize.
      # @param [Integer] id PDF object id.
      # @param [integer] revision PDF object revision.
      def initialize(id, revision = 0)
        raise(ArgumentError) unless id.is_a?(Integer)
        raise(ArgumentError) unless id > 0
        raise(ArgumentError) unless revision.is_a?(Integer)
        raise(ArgumentError) unless revision >= 0
        @id = id
        @revision = revision
      end

      # Convert to string.
      # @return [String] Content.
      def to_s
        String.new('PDF:').concat(
          @id.to_s, '-', @revision.to_s, 'R'
        )
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
        @id.to_s.concat(
          ' ', @revision.to_s, ' R'
        )
      end
    end
  end
end
