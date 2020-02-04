# frozen_string_literal: true

require 'forwardable'
require 'dopp/type'
require 'dopp/section/object_header'

module Dopp
  module Section
    # PDF document section "content stream".
    class Content
      extend Forwardable
      include ::Dopp::Type

      # Delegate methods of ObjectHeader.
      def_delegators :@object_header,
        :ref, :id, :id=, :revision, :revision=

      # Initialize.
      def initialize
        @object_header = ObjectHeader.new
        # Initialize attributes.
        @attrs = dict({
          name(:Length) => 0,
        })
        # Initialize stream.
        @stream = String.new
@stream << "200 150 m 600 450 l S"
@attrs[name(:Length)] = @stream.size + 2
      end

      # Render to string.
      # @return [String] Content.
      def render
        @object_header.render.concat(
          @attrs.render, LF,
          'stream', LF, @stream, LF,
          'endstream', LF, 'endobj', LF)
      end
    end
  end
end

