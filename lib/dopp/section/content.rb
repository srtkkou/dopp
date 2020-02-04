# frozen_string_literal: true

require 'forwardable'
require 'dopp/type'
require 'dopp/section/section_header'

module Dopp
  module Section
    # PDF document section "content stream".
    class Content
      extend Forwardable
      include ::Dopp::Type

      # Delegate methods of ObjectHeader.
      def_delegators :@section_header,
        *%i[ref id revision revision=]

      # Initialize.
      # @param [::Dopp::Document] doc PDF document.
      def initialize(doc)
        raise(ArgumentError) unless doc.is_a?(::Dopp::Document)
        # Initialize variables.
        @document = doc
        @section_header = SectionHeader.new(doc)
        # Initialize attributes.
        @attrs = dict({})
        # Initialize stream.
        @stream = String.new
      end

      # Render to string.
      # @return [String] Content.
      def render
        # Update attributes.
        @stream = '200 150 m 600 450 l S' # TODO: Remove.
        # Calculate length (stream bytes + (LF * 2)).
        length = @stream.size + 2
        @attrs[name(:Length)] = length
        # Render content.
        @section_header.render.concat(
          @attrs.render, LF,
          'stream', LF, @stream, LF,
          'endstream', LF, 'endobj', LF)
      end
    end
  end
end
