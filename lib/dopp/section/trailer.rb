# frozen_string_literal: true

require 'securerandom'
require 'dopp/section/catalog'
require 'dopp/section/info'

module Dopp
  module Section
    # PDF document section trailer
    class Trailer
      include ::Dopp::Error
      include ::Dopp::Type

      # Initialize.
      def initialize
        @xref_offset = 0
        @attributes = dict(Size: 0)
        generate_ids
      end

      # Set offset to cross reference table.
      # @param [Integer] offset Offset.
      def xref_offset=(offset)
        check_is_a!(offset, Integer)
        check_gt!(offset, 0)
        @xref_offset = offset
      end

      # Set size of entries in cross reference table.
      # @param [Integer] size Size of entries.
      def size=(size)
        check_is_a!(size, Integer)
        check_gt!(size, 0)
        @attributes[:Size] = size
      end

      # Set document catalogue.
      # @param [::Dopp::Section::Catalog] catalog Document catalog.
      def catalog=(catalog)
        check_is_a!(catalog, ::Dopp::Section::Catalog)
        @attributes[:Root] = catalog.ref
      end

      # Set document information dictionary.
      # @param [::Dopp::Section::Info] info Information dictionary.
      def info=(info)
        check_is_a!(info, ::Dopp::Section::Info)
        @attributes[:Info] = info.ref
      end

      # Render to string.
      # @return [String] Content.
      def render
        check_is_a!(@xref_offset, Integer)
        check_gt!(@xref_offset, 0)
        check_is_a!(@attributes[:Root], ::Dopp::Type::Reference)
        check_is_a!(@attributes[:Info], ::Dopp::Type::Reference)
        check_is_a!(@attributes[:Size], Integer)
        check_gt!(@attributes[:Size], 0)
        # Render content.
        String.new('trailer').concat(
          LF, @attributes.render, LF, 'startxref', LF,
          @xref_offset.to_s, LF, '%%EOF', LF
        )
      end

      private

      # Generate document and revision ID.
      # @return [Array<::Dopp::Type::HexString>] IDs.
      def generate_ids
        hex_str = SecureRandom.hex(32)
        bytes = hex_str.scan(/.{1,2}/).map do |h|
          Integer(h, 16)
        end
        @doc_id = xtext(bytes[0, 16])
        @rev_id = xtext(bytes[16, 16])
        @attributes[:ID] = list([@doc_id, @rev_id])
      end
    end
  end
end
