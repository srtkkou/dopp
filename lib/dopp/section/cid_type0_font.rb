# frozen_string_literal: true

require 'forwardable'
require 'dopp/type'
require 'dopp/document'
require 'dopp/section/cid_type0_font_dictionary'

module Dopp
  module Section
    class CidType0Font
      extend Forwardable
      include ::Dopp::Type

      def_delegators :@section_header,
        *%i[ref id revision revision=]

      attr_reader :document
      attr_accessor :fullname
      attr_reader :alias
      attr_accessor :aliases
      attr_accessor :encoding
      attr_accessor :dictionary

      def initialize(doc)
        @document = doc
        @section_header = ::Dopp::Section::SectionHeader.new(doc)
        @alias = doc.unique_font_name
        @attrs = dict({
          name(:Type) => name(:Font),
          name(:Subtype) => name(:Type0),
          name(:Name) => name(@alias),
        })
        @fullname = nil
        @encoding = nil
        @dictionary = nil
      end

      def new_dictionary
        @dictionary = CidType0FontDictionary.new(self)
      end

      def render
        # Update attributes.
        @attrs[name(:BaseFont)] = name(@fullname)
        @attrs[name(:Encoding)] = name(@encoding)
        @attrs[name(:DescendantFonts)] = list([@dictionary.ref])
        # Render contents.
        @section_header.render.concat(
          @attrs.render, LF, 'endobj', LF)
      end
    end
  end
end
