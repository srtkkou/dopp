# frozen_string_literal: true

require 'dopp/section/base'
require 'dopp/section/content'

module Dopp
  module Section
    # PDF document section "page".
    class Page < Base
      include ::Dopp::Error

      attr_reader :content
      attr_reader :context

      # Initialize.
      # @param [::Dopp::Section::Pages] pages PDF pages.
      def initialize(pages, opts = {})
        @parent = pages
        super(@parent.structure)
        # Initialize instance variables.
        @content = ::Dopp::Section::Content.new(self, opts)
        @context = @parent.structure.clone_context
        update_attributes(opts)
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

      private

      # Update attributes.
      # @param [Hash] opts Options.
      def update_attributes(opts)
        @attributes[:Type] = :Page
        @attributes[:Parent] = @parent.ref
        @attributes[:Resources] = dict({})
        @attributes[:Contents] = list([@content.ref])
        %i[page_size landscape rotate].each do |attr|
          value = opts[attr]
          __send__("#{attr}=", value) unless value.nil?
        end
      end
    end
  end
end
