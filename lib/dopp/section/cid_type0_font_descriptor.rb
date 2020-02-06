# frozen_string_literal: true

require 'forwardable'
require 'dopp/type'
require 'dopp/document'
require 'dopp/section/cid_type0_font'
require 'dopp/section/cid_type0_font_dictionary'

module Dopp
  module Section
    class CidType0FontDescriptor
      extend Forwardable
      include ::Dopp::Type

      def_delegators :@section_header,
        *%i[ref id revision revision=]

      attr_reader :font_dictionary
      attr_reader :font
      attr_reader :document
      attr_accessor :flags
      attr_accessor :b_box
      attr_accessor :italic_angle
      attr_accessor :ascent
      attr_accessor :descent
      attr_accessor :cap_height
      attr_accessor :stem_v

      def initialize(dict)
        @font_dictionary = dict
        @font = @font_dictionary.font
        @document = @font.document
        @section_header = ::Dopp::Section::SectionHeader.new(@document)
        @attrs = dict({
          name(:Type) => name(:FontDescriptor),
          name(:FontName) => name(@font.fullname),
        })
        @flags = nil
        @b_box = nil
        @italic_angle = nil
        @ascent = nil
        @descent = nil
        @cap_height = nil
        @stem_v = nil
      end

      def render
        # Update attributes.
        @attrs[name(:Flags)] = @flags
        @attrs[name(:FontBBox)] = list(@b_box)
        @attrs[name(:ItalicAngle)] = @italic_angle
        @attrs[name(:Ascent)] = @ascent
        @attrs[name(:Descent)] = @descent
        @attrs[name(:CapHeight)] = @cap_height
        @attrs[name(:StemV)] = @stem_v
        # Render contents.
        @section_header.render.concat(
          @attrs.render, LF, 'endobj', LF)
      end
    end
  end
end
