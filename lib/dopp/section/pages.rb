# frozen_string_literal: true

require 'forwardable'
require 'dopp/type'
require 'dopp/section/section_header'
require 'dopp/section/page'

module Dopp
  module Section
    # PDF document section "pages".
    class Pages
      extend Forwardable
      include ::Dopp::Type

      # Delegate methods of SectionHeader.
      def_delegators :@section_header,
        *%i[ref id revision revision=]

      # Initialize.
      # @param [::Dopp::Document] doc PDF document.
      def initialize(doc)
        raise(ArgumentError) unless doc.is_a?(::Dopp::Document)
        # Set variables.
        @document = doc
        @section_header = SectionHeader.new(doc)
        # Initialize attributes.
        @attrs = dict({
          name(:Type) => name(:Pages),
        })
        @pages = []
      end

      # Append  page.
      # @return [::Dopp::Section::Page] page Page object.
      def append_page
        page = Page.new(@document)
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
        @section_header.render.concat(
          @attrs.render, LF, 'endobj', LF)
      end
    end
  end
end
