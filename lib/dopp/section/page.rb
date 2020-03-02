# frozen_string_literal: true

require 'forwardable'
require 'dopp/document/page_context'
require 'dopp/section/base'
require 'dopp/section/pages'
require 'dopp/section/content'

module Dopp
  module Section
    # PDF document section "page".
    class Page < Base
      extend Forwardable
      include ::Dopp::Error

      def_delegators(
        :@context,
        :page_size, :landscape, :rotate,
        :page_width, :page_height
      )

      attr_reader :content
      attr_reader :context

      # Initialize.
      # @param [::Dopp::Section::Pages] pages PDF pages.
      def initialize(pages, opts = {})
        check_is_a!(pages, ::Dopp::Section::Pages)
        @parent = pages
        super(pages.structure)
        # Initialize page context.
        @context = pages.structure.document.context.dup
        self.page_size = opts[:page_size] if opts[:page_size]
        self.landscape = opts[:landscape] if opts[:landscape]
        self.rotate = opts[:rotate] if opts[:rotate]
        # Initialize attributes.
        @attributes[:Type] = :Page
        @attributes[:Parent] = @parent.ref
        @attributes[:Resources] = dict({})
        # Initialize instance variables.
        @content = ::Dopp::Section::Content.new(self, opts)
        attributes[kw(:Contents)] = list([@content.ref])
      end

      # Add font in resources.
      # @param [::Dopp::Section::Base] font Font section.
      def add_font(font)
        key = kw(font.alias)
        @attributes[:Resources][:Font] ||= dict({})
        @attributes[:Resources][:Font][key] = font.ref
      end

      # Set page size.
      # @param [Symbol] value Page size.
      def page_size=(value)
        @context.page_size = value
        @attributes[:MediaBox] = @context.media_box
      end

      # Set page shape: portrait or landscape.
      # @param [Bool] value True=landscape, false=portrait.
      def landscape=(value)
        @context.landscape = value
        @attributes[:MediaBox] = @context.media_box
      end

      # Set page rotation angle.
      # @param [Integer] value Angle.
      def rotate=(value)
        @context.rotate = value
        @attributes[:Rotate] = @context.rotate
      end
    end
  end
end
