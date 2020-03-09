# frozen_string_literal: true

require 'forwardable'
require 'dopp/section/base'
require 'dopp/canvas'
require 'dopp/shape'

module Dopp
  module Section
    # PDF document section "content stream".
    class Content < Base
      extend Forwardable
      include ::Dopp::Shape

      def_delegators(
        :@page,
        :page_size=, :landscape=, :rotate=,
        :page_size, :landscape, :rotate, :context
      )

      attr_reader :page
      attr_reader :shapes

      # Initialize.
      # @param [::Dopp::Section::Page] page PDF page.
      def initialize(page, opts = {})
        @page = page
        super(@page.structure)
        @shapes = []
        @font = nil
      end

      # Specify font to use.
      # @param [String] name Font name.
      # @param [Hash] opts Font options.
      def use_font(name, opts = {})
        @font = @structure.find_or_initialize_font(name, opts)
        @page.add_font(@font)
        @font
      end

      # Render to string.
      # @return [String] Content.
      def render
        @shapes.each do |shape|
          @stream << shape.render
        end
        super
      end
    end
  end
end
