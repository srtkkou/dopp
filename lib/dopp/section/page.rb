# frozen_string_literal: true

require 'forwardable'
require 'dopp/type'
require 'dopp/section/object_header'

module Dopp
  module Section
    # PDF document section "page".
    class Page
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
          name(:Type) => name(:Page),
          name(:MediaBox) =>
            list([0, 0, 612, 792]),
          name(:Rotate) => 0,
          name(:Resources) => dict({}),
        })
        @parent = nil
        @contents = [::Dopp::Section::Content.new]
      end

      # Set "Pages" object.
      # @param [::Dopp::Section::Pages] parent Pages object.
      def parent=(parent)
        raise(ArgumentError) unless
          parent.is_a?(::Dopp::Section::Pages)
        @parent = parent
      end

      def content_at(index)
        content = @contents[index]
        raise(ArgumentError) if content.nil?
        content
      end

      # Render to string.
      # @return [String] Content.
      def render
        # Update attributes.
        @attrs[name(:Parent)] = @parent.ref
        @attrs[name(:Contents)] = list(@contents.map(&:ref))
        # Render contents.
        @object_header.render.concat(
          @attrs.render, LF, 'endobj', LF)
      end
    end
  end
end

