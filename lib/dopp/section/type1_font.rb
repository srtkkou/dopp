# frozen_string_literal: true

require 'dopp/section/base'

module Dopp
  module Section
    # PDF document section "Type1 font".
    class Type1Font < Base
      attr_reader :fullname
      attr_reader :alias
      attr_accessor :names
      attr_reader :sections

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

      # Update "Widths".
      # @param [Array<Integer>] char_widths Widths of chars.
      def widths=(char_widths)
        check_is_a!(char_widths, Array)
        char_widths.all? do |width|
          check_is_a!(width, Integer)
        end
        attributes[kw(:Widths)] = list(char_widths)
      end

      # Update "FirstChar".
      # @param [Integer] index Index of first char.
      def first_char=(index)
        check_is_a!(index, Integer)
        attributes[kw(:FirstChar)] = index
      end

      # Update "LastChar".
      # @param [Integer] index Index of last char.
      def last_char=(index)
        check_is_a!(index, Integer)
        attributes[kw(:LastChar)] = index
      end

      # Render to string.
      # @return [String] Content.
      def render
        super
      end
    end
  end
end
