# frozen_string_literal: true

require 'dopp/section'

module Dopp
  # PDF document.
  class Document
    # Initialize.
    def initialize
      # Initialize sequential object ID.
      @object_id = 0
      # Initialize headeer.
      @header = ::Dopp::Section::Header.new
      # Initialize document information dictionray.
      @info = ::Dopp::Section::Info.new
      @info.id = next_object_id
      # Initialize root for pages.
      @root = ::Dopp::Section::Pages.new
      @root.id = next_object_id
      # Initialize catalog.
      @catalog = ::Dopp::Section::Catalog.new
      # Initialize cross reference table.
      @xref_table = ::Dopp::Section::XrefTable.new
      # Initialize trailer.
      @trailer = ::Dopp::Section::Trailer.new
      @trailer.info = @info
      @trailer.root = @catalog
      # Other objects.
      @objects = []
    end

    # Append page and content.
    def append_page
      page = @root.append_page
      page.id = next_object_id
      @objects << page
      content = page.content_at(0)
      content.id = next_object_id
      @objects << content
      page
    end

    # TODO
    # def append_page(page)
    #   page.id = next_object_id
    #   @root.append_page(page)
    #   @objects << page
    # end

    # Render to string.
    # @return [String] Content.
    def render
      buffer = @header.render
      # Write info of the document.
      @xref_table.append(buffer.size, 0, 'n')
      buffer << @info.render
      # Write root of pages.
      @catalog.pages = @root.ref
      @xref_table.append(buffer.size, 0, 'n')
      buffer << @root.render
      # Write objects.
      @objects.each do |object|
        @xref_table.append(buffer.size, 0, 'n')
        buffer << object.render
      end
      # Write catalog.
      @catalog.id = (@object_id + 1)
      @catalog.pages = @root.ref
      @xref_table.append(buffer.size, 0, 'n')
      buffer << @catalog.render
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

    private

    # Get and update sequential object ID.
    # @return [Integer] Object ID.
    def next_object_id
      @object_id += 1
    end
  end
end

