# frozen_string_literal: true

require 'dopp/section/base'
require 'dopp/canvas'

module Dopp
  module Section
    # PDF document section "content stream".
    class Content < Base
      attr_reader :page
      attr_reader :canvas

      # Initialize.
      # @param [::Dopp::Document] doc PDF document.
      def initialize(page)
        @page = page
        super(@page.document)
        # Initialize instance variables.
        @canvas = ::Dopp::Canvas.new(self)
        @font = nil
      end

      # Specify font to use.
      # @param [String] name Font name.
      # @param [Hash] opts Font options.
      def use_font(name, opts = {})
        @font = @document.find_or_initialize_font(name, opts)
        @page.add_font(@font)
        @font
      end

      # Render to string.
      # @return [String] Content.
      def render
        @stream << @canvas.render
        super
      end
    end
  end
end
