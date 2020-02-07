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
        attributes[kw(:Type)] = kw(:Page)
        attributes[kw(:MediaBox)] = list([0, 0, 612, 792])
        attributes[kw(:Rotate)] = 0
        attributes[kw(:Resources)] = dict({})
        # Initialize instance variables.
        @parent = nil
        content = ::Dopp::Section::Content.new(doc)
        @contents = [content]
      end

      # Set "Pages" object.
      # @param [::Dopp::Section::Pages] parent Pages object.
      def parent=(parent)
        check_is_a!(parent, ::Dopp::Section::Pages)
        @parent = parent
        attributes[kw(:Parent)] = @parent.ref
      end

      # Use font.
      # @param [String] name Font name.
      # @param [Hash] opts Font options.
      def use_font(name, opts = {})
        font = @document.use_font(name, opts)
        attributes[kw(:Resources)][kw(:Font)] ||= dict({})
        attributes[kw(:Resources)][kw(:Font)][kw(font.alias)] = font.ref
        font
      end

      # TODO: Implement.
      #def write(text)
      #end

      # Render to string.
      # @return [String] Content.
      def render
        check_is_a!(attributes[kw(:Parent)], ::Dopp::Type::Reference)
        # Update attributes.
        attributes[kw(:Contents)] =
          list(@contents.map(&:ref))
        # Render contents.
        super
      end
    end
  end
end
