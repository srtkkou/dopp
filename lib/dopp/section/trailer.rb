# frozen_string_literal: true
require 'securerandom'
require 'dopp/error'
require 'dopp/type'

module Dopp
  module Section
    class Trailer
      include ::Dopp::Type

      # Initialize.
      def initialize
        @xref_offset = 0
        # Initialize attributes.
        doc_id = "<#{SecureRandom.hex(16)}>"
        rev_id = "<#{SecureRandom.hex(16)}>"
        @attrs = dict({
          name(:Size) => 0,
          name(:Root) => nil,
          name(:Info) => nil,
          name(:ID) => list([doc_id, rev_id])
        })
      end

      # Set offset to cross reference table.
      # @param [Integer] offset Offset.
      def xref_offset=(offset)
        raise(ArgumentError) unless
          offset.is_a?(Integer)
        @xref_offset = offset
      end

      # Set reference to the document catalogue.
      # Set size of entries in cross reference table.
      # @param [Integer] size Size of entries.
      def size=(size)
        raise(ArgumentError) unless
          size.is_a?(Integer)
        @attrs[name(:Size)] = size
      end

      # Set reference to the document catalogue.
      # @param [::Dopp::Type::Reference] ref Reference.
      def root=(ref)
        raise(ArgumentError) unless
          ref.is_a?(Type::Reference)
        @attrs[name(:Root)] = ref
      end

      # Set reference to the document information dictionary.
      # @param [::Dopp::Type::Reference] ref Reference.
      def info=(ref)
        raise(ArgumentError) unless
          ref.is_a?(Type::Reference)
        @attrs[name(:Info)] = ref
      end

      # Render to string.
      # @return [String] Content.
      def render
        #raise(::Dopp::ValidationError) if
        #  (@attrs[name(:Size)] == 0)
        #raise(::Dopp::ValidationError) if
        #  @attrs[name(:Root)].nil?
        #raise(::Dopp::ValidationError) if
        #  @attrs[name(:Info)].nil?
        # Render trailer to string.
        String.new('trailer').concat(LF,
          @attrs.render, LF, 'startxref', LF,
          @xref_offset.to_s, LF, '%%EOF', LF)
      end
    end
  end
end

