# frozen_string_literal: true

require 'dopp/error'
require 'dopp/font'
require 'dopp/section'

module Dopp
  class Document
    # PDF document structure.
    class Structure
      include ::Dopp::Error

      attr_reader :document
      attr_reader :header

      # Initialize.
      def initialize(doc, opts = {})
        check_is_a!(doc, ::Dopp::Document)
        @document = doc
        # Initialize instance variables.
        @section_id = 0
        @fonts = {}
        # Initialize top sections.
        @header = ::Dopp::Section::Header.new
        @info = ::Dopp::Section::Info.new(self)
        @catalog = ::Dopp::Section::Catalog.new(self)
        @root = ::Dopp::Section::Pages.new(self)
        @catalog.pages = @root
        @sections = [@info, @catalog, @root]
      end

      # Get unique section ID.
      # Update internal @section_id variable.
      # @return [Integer] Section ID.
      def unique_section_id
        @section_id += 1
      end

      # Get unique font alias.
      # @return [Integer] Font alias.
      def unique_font_alias
        "F#{@fonts.values.uniq.size}"
      end

      # Add new page.
      def add_page(opts = {})
        page = @root.add_page(opts)
        @sections << page
        @sections << page.content
        page.content.canvas
      end

      # Render to string.
      # @return [String] Content.
      def render
        # Initialize bottom sections.
        xref_table = ::Dopp::Section::XrefTable.new
        trailer = ::Dopp::Section::Trailer.new
        trailer.info = @info
        trailer.catalog = @catalog
        # Render sections.
        buffer = @header.render
        @sections.each do |section|
          xref_table.append(buffer.size)
          buffer << section.render
        end
        # Render cross reference table.
        trailer.xref_offset = buffer.size
        buffer << xref_table.render
        # Render trailer.
        trailer.size = xref_table.entry_size
        buffer += trailer.render
        buffer
      end

      # Detailed description of this object.
      # @return [String] Descritption.
      def inspect
        String.new('#<').concat(
          self.class.name, ':',
          object_id.to_s, ' PDF-', @header.version, '>'
        )
      end

      # Find or initialize font to use.
      # @param [String] name Font name.
      # @param [Hash] opts Font options.
      # @return [::Dopp::Section::Base|nil] Font section.
      def find_or_initialize_font(name, opts = {})
        # Find already initialized font.
        font_key = ::Dopp::Font::STORE.font_key(name, opts)
        return @fonts[font_key] if @fonts.key?(font_key)

        # Initialize font.
        builder = ::Dopp::Font::STORE.font_builder(name)
        font = builder.new(self, opts).build
        @sections += font.sections
        # Register font.
        @fonts[font_key] = font
        font.names.each do |font_name|
          key = ::Dopp::Font::STORE.font_key(font_name, opts)
          @fonts[key] = font
        end
        font
      end
    end
  end
end
