# frozen_string_literal: true

require 'dopp/error'
require 'dopp/section/base'

module Dopp
  module Section
    # PDF document section "content stream".
    class Content < Base

      attr_reader :stream

      # Initialize.
      # @param [::Dopp::Document] doc PDF document.
      def initialize(doc)
        super(doc)
        # Initialize instance variables.
        @stream = String.new
      end

      # TODO: Implement real one.
      # Render to string.
      # @return [String] Content.
      def render
        # Update attributes.
        @stream.concat( # TODO: Remove.
          '200 150 m 600 450 l S', LF,
          'BT', LF,
          '/F0 36. Tf', LF,
          #'/F0 36. Tf (Hello World!) Tj', LF,
          utf8_to_xtext('こんにちは').render + ' Tj', LF,
          'ET')
        # Calculate length (stream bytes + (LF * 2)).
        length = @stream.size + 2
        attributes[name(:Length)] = length
        # Render content.
        super do |buf|
          buf.concat('stream', LF, @stream, LF,
            'endstream', LF)
        end
       # @section_header.render.concat(
       #   @attrs.render, LF,
       #   'stream', LF, @stream, LF,
       #   'endstream', LF, 'endobj', LF)
      end
    end
  end
end
