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
      attr_reader :descriptor

      # Initialize.
      # @param [::Dopp::Section::CidType0Font]
      #   font Font section.
      def initialize(font)
        check_is_a!(font, ::Dopp::Section::CidType0Font)
        @font = font
        super(font.document)
        # Initialize attributes.
        attributes[:Type] = :Font
        attributes[:Subtype] = :CIDFontType0
        attributes[:BaseFont] = kw(font.fullname)
        attributes[:CIDSystemInfo] = dict({})
        # Initialize instance variables.
        @descriptor = nil
      end

      # Update "Registry".
      # @param [String] value Font registry.
      def registry=(value)
        check_is_a!(value, String)
        attributes[:CIDSystemInfo][:Registry] = text(value)
      end

      # Update "Ordering".
      # @param [String] value Font ordering.
      def ordering=(value)
        check_is_a!(value, String)
        attributes[:CIDSystemInfo][:Ordering] = text(value)
      end

      # Update "Supplement".
      # @param [Integer] value Font supplement.
      def supplement=(value)
        check_is_a!(value, Integer)
        attributes[:CIDSystemInfo][:Supplement] = value
      end

      # Add new font descriptor.
      # @return [::Dopp::Section::CidType0FontDescriptor]
      #   Font descriptor.
      def new_descriptor
        @descriptor = CidType0FontDescriptor.new(self)
        attributes[:FontDescriptor] = @descriptor.ref
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
