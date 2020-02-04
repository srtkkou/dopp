# frozen_string_literal: true

require 'forwardable'
require 'dopp/type'
require 'dopp/section/object_header'
require 'dopp/section/page'

module Dopp
  module Section
    # PDF document section "pages".
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
        })
        @pages = []
      end

      # Append  page.
      # @return [::Dopp::Section::Page] page Page object.
      def append_page
        page = Page.new
        page.parent = self
        @pages << page
        page
      end

      # TODO
      #def appned_pages
      #end

      # Render to string.
      # @return [String] Content.
      def render
        # Update attributes.
        @attrs[name(:Count)] = @pages.size
        @attrs[name(:Kids)] = list(@pages.map(&:ref))
        # Render content.
        @object_header.render.concat(
          @attrs.render, LF, 'endobj', LF)
      end
    end
  end
end
