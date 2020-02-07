# frozen_string_literal: true

require 'dopp/error'
require 'dopp/section/base'
require 'dopp/section/cid_type0_font'
require 'dopp/section/cid_type0_font_descriptor'

module Dopp
  module Section
    # PDF document section "CID type0 font dictionary".
    class CidType0FontDictionary < Base
      attr_accessor :font
      attr_reader :document
      attr_accessor :registry
      attr_accessor :ordering
      attr_accessor :supplement
      attr_accessor :descriptor

      # Initialize.
      # @param [::Dopp::Section::CidType0Font] font Font section.
      def initialize(font)
        check_is_a!(font, ::Dopp::Section::CidType0Font)
        @font = font
        super(font.document)
        # Initialize attributes.
        attributes[kw(:Type)] = kw(:Font)
        attributes[kw(:Subtype)] = kw(:CIDFontType0)
        attributes[kw(:BaseFont)] = kw(font.fullname)
        # Initialize instance variables.
        @registry = nil
        @ordering = nil
        @supplement = nil
        @descriptor = nil
      end

      # Add new font descriptor.
      # @return [::Dopp::Section::CidType0FontDescriptor]
      #   Font descriptor.
      def new_descriptor
        @descriptor = CidType0FontDescriptor.new(self)
        @font.sections << @descriptor
        @descriptor
      end

      # Render to string.
      # @return [String] Content.
      def render
        # Update attributes.
        attributes[kw(:CIDSystemInfo)] = dict({
          kw(:Registry) => text(@registry),
          kw(:Ordering) => text(@ordering),
          kw(:Supplement) => @supplement
        })
        attributes[kw(:FontDescriptor)] = @descriptor.ref
        # Render contents.
        super
      end
    end
  end
end
