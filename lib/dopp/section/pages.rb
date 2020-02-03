# frozen_string_literal: true
require 'forwardable'
require 'dopp/type'
require 'dopp/section/object_header'

module Dopp
  module Section
    class Pages
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
          name(:Type) => name(:Pages),
          name(:Kids) => list([]),
          name(:Count) => 0,
        })
      end

      # Append  page.
      # @param [::Dopp::Section::Page] page Page object.
      def append_page(page)
        raise(ArgumentError) unless
          page.is_a?(::Dopp::Section::Page)
        page.parent = self
        @attrs[name(:Kids)] << page.ref
        @attrs[name(:Count)] = @attrs[name(:Kids)].size
      end

      # TODO
      #def appned_pages(ref)
      #end

      # Render to string.
      # @return [String] Content.
      def render
        @object_header.render.concat(
          @attrs.render, LF, 'endobj', LF)
      end
    end
  end
end

