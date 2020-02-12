# frozen_string_literal: true

require 'dopp/section/base'
require 'dopp/section/cid_type0_font_dictionary'

module Dopp
  module Section
    # PDF document section "CID type0 font".
    class CidType0Font < Base
      attr_reader :fullname
      attr_reader :alias
      attr_accessor :names
      attr_reader :sections
      attr_reader :dictionary

      # Initialize.
      # @param [::Dopp::Document] doc PDF document.
      def initialize(doc)
        super(doc)
        @alias = doc.unique_font_alias
        # Initialize attributes.
        attributes[kw(:Type)] = kw(:Font)
        attributes[kw(:Subtype)] = kw(:Type0)
        attributes[kw(:Name)] = kw(@alias)
        # Initialize instance variables.
        @sections = [self]
        @fullname = nil
        @dictionary = nil
      end

      # Update fullname ("BaseFont").
      # @param [String] name Base font name.
      def fullname=(name)
        check_is_a!(name, String)
        @fullname = name
        attributes[kw(:BaseFont)] = kw(name)
      end

      # Update "Encoding".
      # @param [String] name Encoding name.
      def encoding=(name)
        check_is_a!(name, String)
        attributes[kw(:Encoding)] = kw(name)
      end

      # Add new font dictionary.
      # @return [::Dopp::Section::CidType0FontDictionary]
      #   Font dictionary.
      def new_dictionary
        @dictionary = CidType0FontDictionary.new(self)
        @sections << @dictionary
        @dictionary
      end

      # Render to string.
      # @return [String] Content.
      def render
        # Update attributes.
        attributes[kw(:DescendantFonts)] =
          list([@dictionary.ref])
        # Render contents.
        super
      end
    end
  end
end
