# frozen_string_literal: true

require 'dopp/error'

module Dopp
  module Type
    # PDF type "Reference".
    class Reference
      include ::Dopp::Error

      # Initialize.
      # @param [Integer] id PDF object id.
      # @param [integer] revision PDF object revision.
      def initialize(id, revision = 0)
        check_is_a!(id, Integer)
        check_gt!(id, 0)
        check_is_a!(revision, Integer)
        check_gteq!(revision, 0)
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
