# frozen_string_literal: true

require 'dopp/error'
require 'dopp/section/base'
require 'dopp/section/pages'
require 'dopp/section/content'

module Dopp
  module Section
    # PDF document section "page".
    class Page < Base
      attr_reader :contents

      # Initialize.
      # @param [::Dopp::Document] doc PDF document.
      def initialize(doc, attrs = {})
        super(doc)
        # Initialize attributes.
        attributes[name(:Type)] = name(:Page)
        attributes[name(:MediaBox)] = list([0, 0, 612, 792])
        attributes[name(:Rotate)] = 0
        # Initialize instance variables.
        @parent = nil
        content = ::Dopp::Section::Content.new(doc)
        @contents = [content]
        @resources = {}
      end

      # Set "Pages" object.
      # @param [::Dopp::Section::Pages] parent Pages object.
      def parent=(parent)
        ::Dopp::Error.check_is_a!(
          parent, ::Dopp::Section::Pages)
        @parent = parent
      end

      # Set font.
      # @param [String] font_name Font name.
      # @param [Hash] opts Font options.
      def set_font(font_name, opts = {})
        font = @document.set_font(font_name, opts)
        @resources[name(:Font)] = dict({
          name(font.alias) => font.ref,
        })
        font
      end

      # TODO: Implement.
      #def write(text)
      #end

      # Render to string.
      # @return [String] Content.
      def render
        # Update attributes.
        attributes[name(:Parent)] = @parent.ref
        attributes[name(:Contents)] =
          list(@contents.map(&:ref))
        attributes[name(:Resources)] = dict(@resources)
        # Render contents.
        super
      end
    end
  end
end
