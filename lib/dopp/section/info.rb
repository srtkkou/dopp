# frozen_string_literal: true

require 'forwardable'
require 'dopp/util'
require 'dopp/type'
require 'dopp/section/section_header'

module Dopp
  module Section
    # PDF document section "information dictionary".
    class Info
      extend Forwardable
      include ::Dopp::Type

      # Delegate methods of ObjectHeader.
      def_delegators :@section_header,
        *%i[ref id revision revision=]

      # Initialize.
      # @param [::Dopp::Document] doc PDF document.
      def initialize(doc)
        raise(ArgumentError) unless doc.is_a?(::Dopp::Document)
        # Set variables.
        @document = doc
        @section_header = SectionHeader.new(doc)
        # Initialize attributes.
        app_name = ::Dopp::APPLICATION.dup.concat(
          '-', ::Dopp::VERSION)
        now_time = time(Time.now)
        @attrs = dict({
          name(:Creator) => text(app_name),
          name(:Producer) => text(app_name),
          name(:CreationDate) => now_time,
          name(:ModDate) => now_time,
        })
      end

      # Set title.
      # @param [String] title Title.
      def title=(title)
        raise(ArgumentError) unless title.is_a?(String)
        if title.ascii_only?
          @attrs[name(:Title)] = text(title)
        else
          @attrs[name(:Title)] = utf8_to_xtext(title)
        end
      end

      # Render to String.
      # @return [String] Content.
      def render
        @section_header.render.concat(
          @attrs.render, LF, 'endobj', LF)
      end
    end
  end
end
