# frozen_string_literal: true

require 'dopp/error'
require 'dopp/type'
require 'dopp/document'

module Dopp
  module Section
    # PDF document section template.
    class Base
      include ::Dopp::Type

      attr_reader :document
      attr_reader :id
      attr_reader :revision
      attr_reader :attributes
      attr_reader :stream

      # Initialize.
      # @param [::Dopp::Document] doc PDF document.
      def initialize(doc)
        ::Dopp::Error.check_is_a!(doc, ::Dopp::Document)
        @document = doc
        @id = doc.unique_section_id
        self.revision = 0
        @attributes = dict({})
        @stream = String.new
      end

      # Get reference to this object.
      # @return [::Dopp::Type;;Reference] Reference.
      def ref
        reference(@id, @revision)
      end

      # Set revision.
      # @param [Integer] rev PDF object revision.
      def revision=(rev)
        ::Dopp::Error.check_is_a!(rev, Integer)
        ::Dopp::Error.check_gteq!(rev, 0)
        @revision = rev
      end

      # Convert to string.
      # @return [String] Content.
      def to_s
        buffer = @id.to_s.concat(
          '-', @revision.to_s, ' ',
          @attributes.to_s
        )
        yield(buffer)
        buffer
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
        # Validate values.
        ::Dopp::Error.check_is_a!(@id, Integer)
        ::Dopp::Error.check_gt!(@id, 0)
        ::Dopp::Error.check_is_a!(@revision, Integer)
        ::Dopp::Error.check_gteq!(@revision, 0)
        # Render to buffer.
        buffer = @id.to_s.concat(
          ' ', @revision.to_s, ' obj', LF,
          @attributes.render, LF
        )
        # Add stream if data exists.
        unless @stream.empty?
          buffer.concat(
            'stream', LF, @stream, LF, 'endstream', LF
          )
        end
        buffer.concat('endobj', LF)
      end
    end
  end
end
