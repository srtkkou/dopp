# frozen_string_literal: true

require 'dopp/error'
require 'dopp/util'
require 'dopp/section/base'

module Dopp
  module Section
    # PDF document section "catalog".
    class Catalog < Base
      # Layouts.
      PAGE_LAYOUTS ||= ::Dopp::Util.deep_freeze([
        :SinglePage,
        :OneColumn,
        :TwoColumnLeft,
        :TwoColumnRight,
        :TwoPageLeft,
        :TwoPageRight
      ])

      # Modes.
      PAGE_MODES ||= ::Dopp::Util.deep_freeze([
        :UseNone,
        :UseOutlines,
        :UseThumbs,
        :FullScreen,
        :UseOC,
        :UseAttachments
      ])

      # Initialize.
      # @param [::Dopp::Document] doc PDF document.
      def initialize(doc, attrs = {})
        super(doc)
        # Initialize attributes.
        attributes[kw(:Type)] = kw(:Catalog)
        self.page_layout = attrs[:page_layout] || :SinglePage
        self.page_mode = attrs[:page_mode] || :UseNone
        # Initialize instance variables.
        @pages = nil
      end

      # Reference to the root "Pages" object.
      # @param [;;Dopp::Section;;Pages] pages PDF section pages.
      def pages=(pages)
        check_is_a!(pages, ::Dopp::Section::Pages)
        @pages = pages
        attributes[kw(:Pages)] = @pages.ref
      end

      # Set page layout.
      # @param [Symbol] layout Layout.
      def page_layout=(layout)
        check_include!(layout, PAGE_LAYOUTS)
        attributes[kw(:PageLayout)] = kw(layout)
      end

      # Set page mode.
      # @param [Symbol] mode Mode.
      def page_mode=(mode)
        check_include!(mode, PAGE_MODES)
        attributes[kw(:PageMode)] = kw(mode)
      end

      # Render to string.
      # @return [String] Content.
      def render
        check_is_a!(attributes[kw(:Pages)], ::Dopp::Type::Reference)
        # Render content.
        super
      end
    end
  end
end
