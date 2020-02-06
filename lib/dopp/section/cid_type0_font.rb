# frozen_string_literal: true

require 'dopp/section/base'
require 'dopp/section/cid_type0_font_dictionary'

module Dopp
  module Section
    # PDF document section "CID type0 font".
    class CidType0Font < Base

      attr_accessor :fullname
      attr_reader :alias
      attr_accessor :aliases
      attr_accessor :encoding
      attr_accessor :dictionary

      # Initialize.
      # @param [::Dopp::Document] doc PDF document.
      def initialize(doc)
        super(doc)
        @alias = doc.unique_font_alias
        # Initialize attributes.
        attributes[name(:Type)] = name(:Font)
        attributes[name(:Subtype)] = name(:Type0)
        attributes[name(:Name)] = name(@alias)
        # Initialize instance variables.
        @fullname = nil
        @encoding = nil
        @dictionary = nil
      end

      def new_dictionary
        @dictionary = CidType0FontDictionary.new(self)
      end

      # Render to string.
      # @return [String] Content.
      def render
        # Update attributes.
        attributes[name(:BaseFont)] = name(@fullname)
        attributes[name(:Encoding)] = name(@encoding)
        attributes[name(:DescendantFonts)] =
          list([@dictionary.ref])
        # Render contents.
        super
      end
    end
  end
end
