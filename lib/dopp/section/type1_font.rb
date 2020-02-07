# frozen_string_literal: true

require 'dopp/section/base'

module Dopp
  module Section
    # PDF document section "Type1 font".
    class Type1Font < Base
      attr_accessor :fullname
      attr_reader :alias
      attr_accessor :names
      attr_accessor :sections
      attr_accessor :encoding
      attr_accessor :widths
      attr_accessor :first_char
      attr_accessor :last_char

      # Initialize.
      # @param [::Dopp::Document] doc PDF document.
      def initialize(doc)
        super(doc)
        @alias = doc.unique_font_alias
        # Initialize attributes.
        attributes[kw(:Type)] = kw(:Font)
        attributes[kw(:Subtype)] = kw(:Type1)
        attributes[kw(:Name)] = kw(@alias)
        # Initialize instance variables.
        @fullname = nil
        @sections = [self]
        @encoding = nil
        @dictionary = nil
      end

      # Render to string.
      # @return [String] Content.
      def render
        # Update attributes.
        attributes[kw(:BaseFont)] = kw(@fullname)
        attributes[kw(:Encoding)] = kw(@encoding)
        attributes[kw(:Widths)] = list(widths)
        attributes[kw(:FirstChar)] = @first_char
        attributes[kw(:LastChar)] = @last_char
        # Render contents.
        super
      end
    end
  end
end
