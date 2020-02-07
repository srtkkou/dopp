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
        attributes[name(:Type)] = name(:Font)
        attributes[name(:Subtype)] = name(:Type1)
        attributes[name(:Name)] = name(@alias)
        # Initialize instance variables.
        @fullname = nil
        @sections [self]
        @encoding = nil
        @dictionary = nil
      end

      # Render to string.
      # @return [String] Content.
      def render
        # Update attributes.
        attributes[name(:BaseFont)] = name(@fullname)
        attributes[name(:Encoding)] = name(@encoding)
        attributes[name(:Widths)] = list(widths)
        attributes[name(:FirstChar)] = @first_char
        attributes[name(:LastChar)] = @last_char
        # Render contents.
        super
      end
    end
  end
end
