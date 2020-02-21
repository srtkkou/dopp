# frozen_string_literal: true

require 'dopp/document/structure'
require 'dopp/util'

module Dopp
  # PDF document.
  class Document
    # Initialize.
    def initialize(opts = {})
      @structure = Structure.new(self, opts)
    end

    # Append page and content.
    def append_page
      @structure.append_page
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
        object_id.to_s, ' PDF-',
        @structure.header.version, '>'
      )
    end
  end
end
