# frozen_string_literal: true

require 'dopp/section'

module Dopp
  # PDF document.
  class Document
    # Initialize.
    def initialize
      # Initialize section ID.
      @section_id = 0
      # Initialize headeer.
      @header = ::Dopp::Section::Header.new(self)
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
    end

    # Get unique section ID.
    # Update internal @section_id variable.
    # @return [Integer] Section ID.
    def unique_section_id
      @section_id += 1
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
  end
end
