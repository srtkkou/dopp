# frozen_string_literal: true

require 'dopp/section/base'

module Dopp
  module Section
    # PDF document section "catalog".
    class Catalog < Base
      # Layouts.
      PAGE_LAYOUTS ||= %i[
        SinglePage OneColumn
        TwoColumnLeft TwoColumnRight
        TwoPageLeft TwoPageRight
      ].tap { |v| ::Dopp::Util.deep_freeze(v) }

      # Modes.
      PAGE_MODES ||= %i[
        UseNone UseOutlines UseThumbs
        FullScreen UseOC UseAttachments
      ].tap { |v| ::Dopp::Util.deep_freeze(v) }

      # Initialize.
      # @param [::Dopp::Document]
      #   structure PDF document structure.
      def initialize(structure, attrs = {})
        super(structure)
        # Initialize attributes.
        attributes[:Type] = :Catalog
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
        attributes[:Pages] = @pages.ref
      end

      # Set page layout.
      # @param [Symbol] layout Layout.
      def page_layout=(layout)
        check_include!(layout, PAGE_LAYOUTS)
        attributes[:PageLayout] = layout
      end

      # Set page mode.
      # @param [Symbol] mode Mode.
      def page_mode=(mode)
        check_include!(mode, PAGE_MODES)
        attributes[:PageMode] = mode
      end

      # Render to string.
      # @return [String] Content.
      def render
        check_is_a!(attributes[:Pages], ::Dopp::Type::Reference)
        # Render content.
        super
      end
    end
  end
end
