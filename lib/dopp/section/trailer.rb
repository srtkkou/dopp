# frozen_string_literal: true

require 'securerandom'
require 'dopp/error'
require 'dopp/type'
require 'dopp/section/catalog'
require 'dopp/section/info'

module Dopp
  module Section
    # PDF document section trailer
    class Trailer
      include ::Dopp::Error
      include ::Dopp::Type

      # Initialize.
      # @param [::Dopp::Document] doc PDF document.
      def initialize(doc)
        check_is_a!(doc, ::Dopp::Document)
        # Set instance variables.
        @document = doc
        @xref_offset = 0
        @root = nil
        @info = nil
        # Initialize attributes.
        @doc_id, @rev_id = generate_ids
        @attrs = dict({
          kw(:Size) => 0,
          kw(:ID) => list([@doc_id, @rev_id])
        })
      end

      # Set offset to cross reference table.
      # @param [Integer] offset Offset.
      def xref_offset=(offset)
        check_is_a!(offset, Integer)
        check_gt!(offset, 0)
        @xref_offset = offset
      end

      # Set reference to the document catalogue.
      # Set size of entries in cross reference table.
      # @param [Integer] size Size of entries.
      def size=(size)
        check_is_a!(size, Integer)
        check_gt!(size, 0)
        @attrs[kw(:Size)] = size
      end

      # Set document catalogue.
      # @param [::Dopp::Section::Catalog] catalog Document catalog.
      def root=(catalog)
        check_is_a!(catalog, ::Dopp::Section::Catalog)
        @root = catalog
        @attrs[kw(:Root)] = @root.ref
      end

      # Set document information dictionary.
      # @param [::Dopp::Section::Info] info Information dictionary.
      def info=(info)
        check_is_a!(info, ::Dopp::Section::Info)
        @info = info
        @attrs[kw(:Info)] = @info.ref
      end

      # Render to string.
      # @return [String] Content.
      def render
        check_is_a!(@xref_offset, Integer)
        check_gt!(@xref_offset, 0)
        check_is_a!(@attrs[kw(:Root)], ::Dopp::Type::Reference)
        check_is_a!(@attrs[kw(:Info)], ::Dopp::Type::Reference)
        check_is_a!(@attrs[kw(:Size)], Integer)
        check_gt!(@attrs[kw(:Size)], 0)
        # Render content.
        String.new('trailer').concat(
          LF, @attrs.render, LF, 'startxref', LF,
          @xref_offset.to_s, LF, '%%EOF', LF
        )
      end

      private

      # Generate document and revision ID.
      # @return [Array<::Dopp::Type::HexString>] IDs.
      def generate_ids
        bytes = SecureRandom.hex(32).scan(/.{1,2}/)
          .map{ |h| Integer(h, 16) }
        doc_id = xtext(bytes[0, 16])
        rev_id = xtext(bytes[16, 16])
        [doc_id, rev_id]
      end
    end
  end
end
