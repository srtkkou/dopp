# frozen_string_literal: true
require 'forwardable'
require 'dopp/type'
require 'dopp/section/object_header'

module Dopp
  module Section
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
          name(:Parent) => nil,
          name(:MediaBox) =>
            list([0, 0, 612, 792]),
        })
      end

      # Set "Pages" object.
      # @param [::Dopp::Section::Pages] pages Pages object.
      def parent=(pages)
        raise(ArgumentError) unless
          pages.is_a?(::Dopp::Section::Pages)
        @attrs[name(:Parent)] = pages.ref
      end

      # Render to string.
      # @return [String] Content.
      def render
        @object_header.render.concat(
          @attrs.render, LF, 'endobj', LF)
      end
    end
  end
end

