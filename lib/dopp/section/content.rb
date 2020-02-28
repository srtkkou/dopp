# frozen_string_literal: true

require 'forwardable'
require 'dopp/section/base'
require 'dopp/canvas'
require 'dopp/shape/text_area'

module Dopp
  module Section
    # PDF document section "content stream".
    class Content < Base
      extend Forwardable

      def_delegators(
        :@page,
        :page_size=, :landscape=, :rotate=,
        :page_size, :landscape, :rotate,
        :page_width, :page_height
      )

      ::Dopp::Shape::TextArea.define_methods(self)

      attr_reader :page

      # Initialize.
      # @param [::Dopp::Section::Page] page PDF page.
      def initialize(page, opts = {})
        @page = page
        super(@page.structure)
        # Initialize instance variables.
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
    end
  end
end
