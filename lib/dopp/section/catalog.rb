# frozen_string_literal: true
require 'forwardable'
require 'dopp/error'
require 'dopp/util'
require 'dopp/type'
require 'dopp/section/object_header'

module Dopp
  module Section
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

      # Delegate methods of ObjectHeader.
      def_delegators :@object_header,
        :ref, :id, :id=, :revision, :revision=

      # Initialize.
      def initialize
        @object_header = ObjectHeader.new
        # Initialize attributes.
        @attrs = dict({
          name(:Type) => name(:Catalog),
          name(:Pages) => nil,
          name(:PageLayout) => name(:SinglePage),
          name(:PageMode) => name(:UseNone),
        })
      end

      # Reference to the root "Pages" object.
      # @param ref 
      def pages=(ref)
        unless ref.is_a?(::Dopp::Type::Reference)
          raise(::Dopp::ValidationError.new(
            "pages=#{ref} should be a Reference."))
        end
        @attrs[name(:Pages)] = ref
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
        @object_header.render.concat(
          @attrs.render, LF, 'endobj', LF)
      end
    end
  end
end

