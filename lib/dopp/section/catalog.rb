# frozen_string_literal: true

require 'forwardable'
require 'dopp/error'
require 'dopp/util'
require 'dopp/type'
require 'dopp/section/section_header'
require 'dopp/section/pages'

module Dopp
  module Section
    # PDF document section "catalog".
    class Catalog
      extend Forwardable
      include ::Dopp::Type

      PAGE_LAYOUTS ||= ::Dopp::Util.deep_freeze([
        :SinglePage,
        :OneColumn,
        :TwoColumnLeft,
        :TwoColumnRight,
        :TwoPageLeft,
        :TwoPageRight,
      ])

      PAGE_MODES ||= ::Dopp::Util.deep_freeze([
        :UseNone,
        :UseOutlines,
        :UseThumbs,
        :FullScreen,
        :UseOC,
        :UseAttachments,
      ])

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
          name(:Type) => name(:Catalog),
          name(:PageLayout) => name(:SinglePage),
          name(:PageMode) => name(:UseNone),
        })
        @pages = nil
      end

      # Reference to the root "Pages" object.
      # @param [;;Dopp::Section;;Pages] pages PDF section pages.
      def pages=(pages)
        raise(ArgumentError) unless
          pages.is_a?(::Dopp::Section::Pages)
        @pages = pages
      end

      def page_layout=(layout)
        unless PAGE_LAYOUTS.include?(layout)
          raise(::Dopp::ValidationError.new(
            "page_layout=#{layout} should be within " \
              "[#{PAGE_LAYOUTS.join(', ')}]."))
        end
        @attrs[name(:PageLayout)] = name(layout)
      end

      def page_mode=(mode)
        unless PAGE_MODES.include?(mode)
          raise(::Dopp::ValidationError.new(
            "page_mode=#{mode} should be within " \
              "[#{PAGE_MODES.join(', ')}]."))
        end
        @attrs[name(:PageMode)] = name(mode)
      end

      # Render to string.
      # @return [String] Content.
      def render
        # Update attributes.
        @attrs[name(:Pages)] = @pages.ref
        # Render content.
        @section_header.render.concat(
          @attrs.render, LF, 'endobj', LF)
      end
    end
  end
end

