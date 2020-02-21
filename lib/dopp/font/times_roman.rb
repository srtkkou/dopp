# frozen_string_literal: true

require 'dopp'
require 'dopp/section/type1_font'

module Dopp
  module Font
    # Type1 font "Times-Roman".
    class TimesRoman
      include ::Dopp::Error

      # Font names.
      NAMES ||= %w[
        Times-Roman
      ].tap { |v| ::Dopp::Util.deep_freeze(v) }

      # Update FONTS_CLASSES.
      NAMES.each do |name|
        STORE.add_font_builder(name, self)
      end

      # Normal font widths.
      NORMAL_WIDTHS ||= [
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
      ].tap { |v| ::Dopp::Util.deep_freeze(v) }

      # Initialize.
      # @param [::Dopp::Document::Structure]
      #   structure PDF document structure.
      def initialize(structure, opts = {})
        check_is_a!(structure, ::Dopp::Document::Structure)
        @opts = opts
        @font = ::Dopp::Section::Type1Font.new(structure)
      end

      # Build font section.
      # @return [::Dopp::Section::Type1Font] Font section.
      def build
        build_common
        normal
      end

      # Build common part of this font.
      def build_common
        @font.encoding = 'StandardEncoding'
        @font.names = NAMES
        # @font.first_char = 0
        # @font.last_char = 256
      end

      # Build normal font.
      # @return [::Dopp::Section::Type1Font] Font section.
      def normal
        @font.fullname = 'Times-Roman'
        @font
      end

      # def bold(doc)
      # end

      # def italic(doc)
      # end

      # def bold_italic(doc)
      # end
    end
  end
end
