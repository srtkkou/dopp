# frozen_literal_string: true

require 'dopp/error'
require 'dopp/type'

module Dopp
  module Section
    # PDF document section header.
    class SectionHeader
      attr_reader :id
      attr_reader :revision

      # Initialize.
      def initialize(doc)
        @document = doc
        @id = doc.unique_section_id
        @revision = 0
      end

      # Get reference to this object.
      # @return [::Dopp::Type;;Reference] Reference to this PDF object.
      def ref
        ::Dopp::Type.reference(@id, @revision)
      end

      # Set revision.
      # @param [Integer] rev PDF object revision.
      def revision=(rev)
        validate_revision!(rev)
        @revision = rev
      end

      # Convert to string.
      # @return [String] Content.
      def to_s
        @id.to_s.concat('-', @revision.to_s)
      end

      # Detailed description of this object.
      # @return [String] Description.
      def inspect
        '#<'.concat(self.class.name, ':',
          self.object_id.to_s, ' ', self.to_s, '>')
      end

      # Render to string.
      # @return [String] Content.
      def render
        validate_id!(@id)
        validate_revision!(@revision)
        @id.to_s.concat(
          ' ', @revision.to_s, ' obj', LF)
      end

      private

      # Check if the ID is valid.
      def validate_id!(id)
        unless id.is_a?(Integer)
          raise(::Dopp::ValidationError.new(
            "id=#{id} should be Integer."))
        end
        unless (id > 0)
          raise(::Dopp::ValidationError.new(
            "id=#{id} should be greater than 0."))
        end
      end

      # Check if the revision is valid.
      def validate_revision!(rev)
        unless rev.is_a?(Integer)
          raise(::Dopp::ValidationError.new(
            "revision=#{rev} should be Integer."))
        end
        unless (id >= 0)
          raise(::Dopp::ValidationError.new(
            "revision=#{rev} should be greater than or equal to 0."))
        end
      end
    end
  end
end
