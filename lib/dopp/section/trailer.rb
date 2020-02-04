# frozen_string_literal: true

require 'securerandom'
require 'dopp/error'
require 'dopp/type'

module Dopp
  module Section
    # PDF document section trailer
    class Trailer
      include ::Dopp::Type

      # Initialize.
      def initialize
        @xref_offset = 0
        # Initialize attributes.
        bytes = SecureRandom.hex(32).scan(/.{1,2}/).
          map{|h| Integer(h, 16)}
        @doc_id = xtext(bytes[0, 16])
        @rev_id = xtext(bytes[16, 16])
        @attrs = dict({
          name(:Size) => 0,
          name(:ID) => list([@doc_id, @rev_id])
        })
        @root = nil
        @info = nil
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

      # Set document catalogue.
      # @param [::Dopp::Section::Catalog] catalog Document catalog.
      def root=(catalog)
        raise(ArgumentError) unless
          catalog.is_a?(::Dopp::Section::Catalog)
        @root = catalog
      end

      # Set document information dictionary.
      # @param [::Dopp::Section::Info] info Information dictionary.
      def info=(info)
        raise(ArgumentError) unless
          info.is_a?(::Dopp::Section::Info)
        @info = info
      end

      # Render to string.
      # @return [String] Content.
      def render
        # Update attributes.
        @attrs[name(:Root)] = @root.ref
        @attrs[name(:Info)] = @info.ref
        #raise(::Dopp::ValidationError) if
        #  (@attrs[name(:Size)] == 0)
        #raise(::Dopp::ValidationError) if
        #  @attrs[name(:Root)].nil?
        #raise(::Dopp::ValidationError) if
        #  @attrs[name(:Info)].nil?
        # Render trailer to string.
        # Render content.
        String.new('trailer').concat(LF,
          @attrs.render, LF, 'startxref', LF,
          @xref_offset.to_s, LF, '%%EOF', LF)
      end
    end
  end
end

