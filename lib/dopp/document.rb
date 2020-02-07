# frozen_string_literal: true

require 'dopp/error'
require 'dopp/section'
require 'dopp/font'

module Dopp
  # PDF document.
  class Document
    include ::Dopp::Error

    # Initialize.
    def initialize
      # Initialize section ID.
      @section_id = 0
      # Initialize headeer.
      @header = ::Dopp::Section::Header.new
      # Initialize document information dictionray.
      @info = ::Dopp::Section::Info.new(self)
      # Initialize catalog.
      @catalog = ::Dopp::Section::Catalog.new(self)
      # Initialize root for pages.
      @root = ::Dopp::Section::Pages.new(self)
      @catalog.pages = @root
      # Initialize cross reference table.
      @xref_table = ::Dopp::Section::XrefTable.new(self)
      # Initialize trailer.
      @trailer = ::Dopp::Section::Trailer.new(self)
      @trailer.info = @info
      @trailer.root = @catalog
      # Other sections.
      @sections = [@info, @catalog, @root]
      # Initialize fonts.
      @fonts = {}
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
      "F#{@fonts.size}"
    end

    # Append page and content.
    def append_page
      page = @root.append_page
      @sections << page
      @sections += page.contents
      page
    end

    # TODO
    # def append_page(page)
    #   page.id = next_object_id
    #   @root.append_page(page)
    #   @sections << page
    # end

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
      String.new('#<').concat(self.class.name, ':',
        self.object_id.to_s, ' PDF-', @header.version, '>')
    end

    # Specify font to use or initialize it.
    # @param [String] name Font name.
    # @param [Hash] opts Font options.
    # @return [::Dopp::Section::Base|nil] Font section.
    def use_font(name, opts = {})
      font_key = ::Dopp::Font.font_key(name)
      font = @fonts[font_key]
      return font unless font.nil?

      mod = ::Dopp::Font::FONT_MODULES[font_key]
      font = mod.build(self, opts)
      check_is_a!(font, ::Dopp::Section::Base)
      @fonts[font_key] = font
      font.names.each do |name|
        key = ::Dopp::Font.font_key(name)
        @fonts[key] = font
      end
      @sections += font.sections
      font
    end
  end
end
