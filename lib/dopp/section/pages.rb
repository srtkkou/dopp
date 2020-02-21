# frozen_string_literal: true

require 'dopp/section/base'
require 'dopp/section/page'

module Dopp
  module Section
    # PDF document section "pages".
    class Pages < Base
      # Initialize.
      # @param [::Dopp::Document::Structure]
      #   structure PDF document structure.
      def initialize(structure)
        super(structure)
        # Initialize attributes.
        attributes[:Type] = :Pages
        # Initialize instance variables.
        @pages = []
      end

      # Append  page.
      # @return [::Dopp::Section::Page] page Page object.
      def append_page
        page = Page.new(self)
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
        attributes[:Count] = @pages.size
        attributes[:Kids] = list(@pages.map(&:ref))
        # Render content.
        super
      end
    end
  end
end
