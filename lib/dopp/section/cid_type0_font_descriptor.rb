# frozen_string_literal: true

require 'dopp/error'
require 'dopp/section/base'
require 'dopp/section/cid_type0_font'
require 'dopp/section/cid_type0_font_dictionary'

module Dopp
  module Section
    # PDF document section "CID type0 font descriptor."
    class CidType0FontDescriptor < Base
      attr_reader :font_dictionary
      attr_reader :font
      attr_reader :document
      attr_accessor :flags
      attr_accessor :b_box
      attr_accessor :italic_angle
      attr_accessor :ascent
      attr_accessor :descent
      attr_accessor :cap_height
      attr_accessor :stem_v

      # Initialize.
      # @param [::Dopp::Section::CIDType0FontDictionary]
      #   dict Font dictionary section.
      def initialize(dict)
        ::Dopp::Error.check_is_a!(
          dict, ::Dopp::Section::CidType0FontDictionary
        )
        @font_dictionary = dict
        @font = @font_dictionary.font
        super(@font.document)
        # Initialize attributes.
        attributes[kw(:Type)] = kw(:FontDescriptor)
        attributes[kw(:FontName)] = kw(@font.fullname)
        # Initialize instance variables.
        @flags = nil
        @b_box = nil
        @italic_angle = nil
        @ascent = nil
        @descent = nil
        @cap_height = nil
        @stem_v = nil
      end

      # Render to string.
      # @return [String] Content.
      def render
        # Update attributes.
        attributes[kw(:Flags)] = @flags
        attributes[kw(:FontBBox)] = list(@b_box)
        attributes[kw(:ItalicAngle)] = @italic_angle
        attributes[kw(:Ascent)] = @ascent
        attributes[kw(:Descent)] = @descent
        attributes[kw(:CapHeight)] = @cap_height
        attributes[kw(:StemV)] = @stem_v
        # Render contents.
        super
      end
    end
  end
end
