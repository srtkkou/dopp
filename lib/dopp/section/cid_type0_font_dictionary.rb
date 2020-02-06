# frozen_string_literal: true

require 'forwardable'
require 'dopp/type'
require 'dopp/document'
require 'dopp/section/cid_type0_font'
require 'dopp/section/cid_type0_font_descriptor'

module Dopp
  module Section
    class CidType0FontDictionary
      extend Forwardable
      include ::Dopp::Type

      def_delegators :@section_header,
        *%i[ref id revision revision=]

      attr_accessor :font
      attr_reader :document
      attr_accessor :registry
      attr_accessor :ordering
      attr_accessor :supplement
      attr_accessor :descriptor

      def initialize(font)
        @font = font
        @document = @font.document
        @section_header = ::Dopp::Section::SectionHeader.new(@document)
        @attrs = dict({
          name(:Type) => name(:Font),
          name(:Subtype) => name(:CIDFontType0),
          name(:BaseFont) => name(font.fullname),
        })
        @registry = nil
        @ordering = nil
        @supplement = nil
        @descriptor = nil
      end

      def new_descriptor
        @descriptor = CidType0FontDescriptor.new(self)
      end

      def render
        # Update attributes.
        @attrs[name(:CIDSystemInfo)] = dict({
          name(:Registry) => text(@registry),
          name(:Ordering) => text(@ordering),
          name(:Supplement) => @supplement
        })
        @attrs[name(:FontDescriptor)] = @descriptor.ref
        # Render contents.
        @section_header.render.concat(
          @attrs.render, LF, 'endobj', LF)
      end
    end
  end
end
