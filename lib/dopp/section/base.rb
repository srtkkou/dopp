# frozen_string_literal: true

require 'dopp'
require 'dopp/type'
require 'dopp/section/stream'

module Dopp
  module Section
    # PDF document section template.
    class Base
      include ::Dopp::Error
      include ::Dopp::Type

      attr_reader :structure
      attr_reader :document
      attr_reader :id
      attr_reader :revision
      attr_reader :attributes
      attr_reader :stream

      # Initialize.
      # @param [::Dopp::Document::Structure]
      #   structure PDF document structure.
      def initialize(structure)
        check_is_a!(structure, ::Dopp::Document::Structure)
        @structure = structure
        @document = structure.document
        @id = @structure.unique_section_id
        @revision = 0
        @attributes = dict({})
        @stream = ::Dopp::Section::Stream.new
        @stream.flate_decode = true
      end

      # Get reference to this object.
      # @return [::Dopp::Type;;Reference] Reference.
      def ref
        reference(@id, @revision)
      end

      # Set revision.
      # @param [Integer] rev PDF object revision.
      def revision=(rev)
        check_is_a!(rev, Integer)
        check_gteq!(rev, 0)
        @revision = rev
      end

      # Convert to string.
      # @return [String] Content.
      def to_s
        buffer = @id.to_s.concat(
          '-', @revision.to_s, ' ',
          @attributes.to_s
        )
        yield(buffer) if block_given?
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
        check_is_a!(@revision, Integer)
        check_gteq!(@revision, 0)
        # Render stream.
        stream_bytes = @stream.render
        unless stream_bytes.empty?
          @attributes[:Length] = stream_bytes.size
          add_filter(:FlateDecode) if stream.flate_decode
        end
        # Render to buffer.
        buffer = @id.to_s.concat(
          ' ', @revision.to_s, ' obj', LF,
          @attributes.render, LF
        )
        # Add stream if data exists.
        unless stream_bytes.empty?
          buffer.concat('stream', stream_bytes, 'endstream', LF)
        end
        buffer.concat('endobj', LF)
      end

      private

      # Add filter attribute.
      def add_filter(filter)
        filter = kw(filter) if filter.is_a?(Symbol)
        @attributes[:Filter] ||= list([])
        return if @attributes[:Filter].include?(filter)

        @attributes[:Filter] << filter
      end

      # Set attributes from options.
      def options_to_attributes(opts)
        opts.each do |key, value|
          setter = key.to_s.concat('=')
          next if value.nil?
          next unless self.class.public_method_defined?(setter)

          self.__send__(setter, value)
        end
      end
    end
  end
end
