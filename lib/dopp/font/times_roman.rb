# frozen_string_literal: true

require 'dopp/util'
require 'dopp/font'
require 'dopp/document'
require 'dopp/section/type1_font'

module Dopp
  module Font
    # Type1 font "Times-Roman".
    module TimesRoman
      # Font names.
      NAMES ||= ::Dopp::Util.deep_freeze(['Times-Roman'])

      # Update FONTS_CLASSES.
      NAMES.each do |name|
        STORE.add_font_module(name, self)
      end

      module_function

      # Build font section.
      # @param [::Dopp::Document] doc PDF document.
      # @return [::Dopp::Section::Type1Font] Font.
      def build(doc, opts = {})
        times_roman_normal(doc)
      end

      def times_roman_normal(doc)
        font = ::Dopp::Section::Type1Font.new(doc)
        font.fullname = 'Times-Roman'
        font.encoding = 'StandardEncoding'
        font.names = NAMES
        font.widths = [
          250,  250, 250,  250, 250, 250, 250,  250, 250, 250,
          250,  250, 250,  250, 250, 250, 250,  250, 250, 250,
          250,  250, 250,  250, 250, 250, 250,  250, 250, 250,
          250,  250, 250,  333, 408, 500, 500,  833, 778, 180,
          333,  333, 500,  564, 250, 333, 250,  278, 500, 500,
          500,  500, 500,  500, 500, 500, 500,  500, 278, 278,
          564,  564, 564,  444, 921, 722, 667,  667, 722, 611,
          556,  722, 722,  333, 389, 722, 611,  889, 722, 722,
          556,  722, 667,  556, 611, 722, 722,  944, 722, 722,
          611,  333, 278,  333, 469, 500, 333,  444, 500, 444,
          500,  444, 333,  500, 500, 278, 278,  500, 278, 778,
          500,  500, 500,  500, 333, 389, 278,  500, 500, 722,
          500,  500, 444,  480, 200, 480, 541,  350, 500, 350,
          333,  500, 444, 1000, 500, 500, 333, 1000, 556, 333,
          889,  350, 611,  350, 350, 333, 333,  444, 444, 350,
          500, 1000, 333,  980, 389, 333, 722,  350, 444, 722,
          250,  333, 500,  500, 500, 500, 200,  500, 333, 760,
          276,  500, 564,  333, 760, 333, 400,  564, 300, 300,
          333,  500, 453,  250, 333, 300, 310,  500, 750, 750,
          750,  444, 722,  722, 722, 722, 722,  722, 889, 667,
          611,  611, 611,  611, 333, 333, 333,  333, 722, 722,
          722,  722, 722,  722, 722, 564, 722,  722, 722, 722,
          722,  722, 556,  500, 444, 444, 444,  444, 444, 444,
          667,  444, 444,  444, 444, 444, 278,  278, 278, 278,
          500,  500, 500,  500, 500, 500, 500,  564, 500, 500,
          500,  500, 500,  500, 500, 500
        ]
        font.first_char = 0
        font.last_char = font.widths.size
        font
      end

      def times_roman_bold
      end

      def times_roman_italic
      end

      def times_roman_bold_italic
      end
    end
  end
end
