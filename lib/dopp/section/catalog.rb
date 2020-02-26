# frozen_string_literal: true

require 'dopp/section/base'

module Dopp
  module Section
    # PDF document section "catalog".
    class Catalog < Base
      # Default options.
      DEFAULT_OPTS ||= ::Dopp::Util.deep_freeze(
        page_layout: :SinglePage,
        page_mode: :UseThumbs
      )

      attr_reader :pages_root

      # Initialize.
      # @param [::Dopp::Document]
      #   structure PDF document structure.
      def initialize(structure, opts = {})
        super(structure)
        # Initialize attributes.
        options_to_attributes(DEFAULT_OPTS.dup.merge(opts))
        attributes[:Type] = :Catalog
        @pages_root = ::Dopp::Section::Pages.new(self)
        attributes[:Pages] = @pages_root.ref
      end

      # Set page layout.
      # @param [Symbol] layout Layout.
      def page_layout=(layout)
        check_include!(layout, ::Dopp::PAGE_LAYOUTS)
        attributes[:PageLayout] = layout
      end

      # Set page mode.
      # @param [Symbol] mode Mode.
      def page_mode=(mode)
        check_include!(mode, ::Dopp::PAGE_MODES)
        attributes[:PageMode] = mode
      end
    end
  end
end
