# frozen_string_literal: true

require 'dopp/error'
require 'dopp/font'
require 'dopp/section'

module Dopp
  # PDF document.
  class Document
    include ::Dopp::Error

    # Initialize.
    def initialize
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
      # Initialize bottom sections.
      @xref_table = ::Dopp::Section::XrefTable.new(self)
      @trailer = ::Dopp::Section::Trailer.new(self)
      @trailer.info = @info
      @trailer.root = @catalog
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

    # Append page and content.
    def append_page
      page = @root.append_page
      @sections << page
      @sections << page.content
      page.content
    end

    # Render to string.
    # @return [String] Content.
    def render
      @xref_table.clear
      buffer = @header.render
      # Render sections.
      @sections.each do |section|
        @xref_table.append(buffer.size)
        buffer << section.render
      end
      # Write cross reference table.
      @trailer.xref_offset = buffer.size
      buffer << @xref_table.render
      # Write trailer.
      @trailer.size = @xref_table.entry_size
      buffer += @trailer.render
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
      mod = ::Dopp::Font::STORE.font_module(name)
      font = mod.build(self, opts)
      @sections += font.sections
      # Register font.
      @fonts[font_key] = font
      font.names.each do |name|
        key = ::Dopp::Font::STORE.font_key(name, opts)
        @fonts[key] = font
      end
      font
    end
  end
end
