# frozen_string_literal: true

require 'forwardable'
require 'dopp/type'
require 'dopp/section/section_header'
require 'dopp/section/pages'
require 'dopp/section/content'

module Dopp
  module Section
    # PDF document section "page".
    class Page
      extend Forwardable
      include ::Dopp::Type

      # Delegate methods of SectionHeader.
      def_delegators :@section_header,
        *%i[ref id revision revision=]

      attr_reader :contents

      # Initialize.
      # @param [::Dopp::Document] doc PDF document.
      def initialize(doc)
        raise(ArgumentError) unless doc.is_a?(::Dopp::Document)
        # Set variables.
        @document = doc
        @section_header = SectionHeader.new(doc)
        # Initialize attributes.
        @attrs = dict({
          name(:Type) => name(:Page),
          name(:MediaBox) =>
            list([0, 0, 612, 792]),
          name(:Rotate) => 0,
          name(:Resources) => dict({}),
        })
        @parent = nil
        content = ::Dopp::Section::Content.new(doc)
        @contents = [content]
      end

      # Set "Pages" object.
      # @param [::Dopp::Section::Pages] parent Pages object.
      def parent=(parent)
        raise(ArgumentError) unless
          parent.is_a?(::Dopp::Section::Pages)
        @parent = parent
      end

      # Render to string.
      # @return [String] Content.
      def render
        # Update attributes.
        @attrs[name(:Parent)] = @parent.ref
        @attrs[name(:Contents)] =
          list(@contents.map(&:ref))
        # Render contents.
        @section_header.render.concat(
          @attrs.render, LF, 'endobj', LF)
      end
    end
  end
end
