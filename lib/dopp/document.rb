# frozen_string_literal: true

require 'forwardable'
require 'dopp/document/page_context'
require 'dopp/document/structure'

module Dopp
  # PDF document.
  class Document
    extend Forwardable

    def_delegators(
      :@page_context,
      :page_size=, :landscape=, :rotate=,
      :page_size, :landscape, :rotate,
      :page_width, :page_height
    )
    def_delegators(
      :@structure,
      :pdf_version=,
      :title=, :mod_date=,
      :page_layout=, :page_mode=
    )

    attr_reader :page_context

    # Initialize.
    def initialize(opts = {})
      @page_context = PageContext.new(opts)
      @structure = Structure.new(self, opts)
    end

    # Add new page.
    def add_page(opts = {})
      @structure.add_page(opts)
    end

    # Render to string.
    # @return [String] Content.
    def render
      @structure.render
    end

    # Detailed description of this object.
    # @return [String] Descritption.
    def inspect
      String.new('#<').concat(
        self.class.name, ':',
        object_id.to_s, ' ', @structure.to_s, '>'
      )
    end
  end
end
