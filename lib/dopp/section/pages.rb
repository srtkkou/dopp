# frozen_string_literal: true

require 'dopp/error'
require 'dopp/section/base'
require 'dopp/section/page'

module Dopp
  module Section
    # PDF document section "pages".
    class Pages < Base
      # Initialize.
      # @param [::Dopp::Document] doc PDF document.
      def initialize(doc, attrs = {})
        super(doc)
        # Initialize attributes.
        attributes[kw(:Type)] = kw(:Pages)
        # Initialize instance variables.
        @pages = []
      end

      # TODO: Reconsider method name.
      # Append  page.
      # @return [::Dopp::Section::Page] page Page object.
      def append_page
        page = Page.new(@document)
        page.parent = self
        @pages << page
        page
      end

      # TODO: Implement
      # def appned_pages
      # end

      # Render to string.
      # @return [String] Content.
      def render
        # Update attributes.
        attributes[kw(:Count)] = @pages.size
        attributes[kw(:Kids)] = list(@pages.map(&:ref))
        # Render content.
        super
      end
    end
  end
end
