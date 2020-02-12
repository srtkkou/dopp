# frozen_string_literal: true

require 'dopp/error'
require 'dopp/section/base'
require 'dopp/section/cid_type0_font'
require 'dopp/section/cid_type0_font_descriptor'

module Dopp
  module Section
    # PDF document section "CID type0 font dictionary".
    class CidType0FontDictionary < Base
      attr_reader :font
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
        attributes[kw(:CIDSystemInfo)] = dict({})
        # Initialize instance variables.
        @descriptor = nil
      end

      # Update "Registry".
      # @param [String] reg Font registry.
      def registry=(reg)
        check_is_a!(reg, String)
        attributes[kw(:CIDSystemInfo)]
          .store(kw(:Registry), text(reg))
      end

      # Update "Ordering".
      # @param [String] order Font ordering.
      def ordering=(order)
        check_is_a!(order, String)
        attributes[kw(:CIDSystemInfo)]
          .store(kw(:Ordering), text(order))
      end

      # Update "Supplement".
      # @param [Integer] sup Font supplement.
      def supplement=(sup)
        check_is_a!(sup, Integer)
        attributes[kw(:CIDSystemInfo)]
          .store(kw(:Supplement), sup)
      end

      # Add new font descriptor.
      # @return [::Dopp::Section::CidType0FontDescriptor]
      #   Font descriptor.
      def new_descriptor
        @descriptor = CidType0FontDescriptor.new(self)
        attributes[kw(:FontDescriptor)] = @descriptor.ref
        @font.sections << @descriptor
        @descriptor
      end

      # Render to string.
      # @return [String] Content.
      def render
        super
      end
    end
  end
end
