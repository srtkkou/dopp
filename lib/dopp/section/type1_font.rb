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
      # @param [String] value Base font name.
      def fullname=(value)
        check_is_a!(value, String)
        @fullname = value
        attributes[kw(:BaseFont)] = kw(value)
      end

      # Update "Encoding".
      # @param [String] value Encoding name.
      def encoding=(value)
        check_is_a!(value, String)
        attributes[kw(:Encoding)] = kw(value)
      end

      # Update "Widths".
      # @param [Array<Integer>] char_widths Widths of chars.
      def widths=(values)
        check_is_a!(values, Array)
        values.each do |value|
          check_is_a!(value, Integer)
        end
        attributes[kw(:Widths)] = list(values)
      end

      # Update "FirstChar".
      # @param [Integer] value Index of first char.
      def first_char=(value)
        check_is_a!(value, Integer)
        attributes[kw(:FirstChar)] = value
      end

      # Update "LastChar".
      # @param [Integer] value Index of last char.
      def last_char=(value)
        check_is_a!(value, Integer)
        attributes[kw(:LastChar)] = value
      end

      # Render to string.
      # @return [String] Content.
      def render
        super
      end
    end
  end
end
