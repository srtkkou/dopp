# frozen_string_literal: true

require 'forwardable'
require 'dopp/util'
require 'dopp/type'
require 'dopp/section/object_header'

module Dopp
  module Section
    # PDF document section "information dictionary".
    class Info
      extend Forwardable
      include ::Dopp::Type

      # Delegate methods of ObjectHeader.
      def_delegators :@object_header,
        :ref, :id, :id=, :revision, :revision=

      # Initialize.
      def initialize
        @object_header = ObjectHeader.new
        # Initialize attributes.
        app_name = APPLICATION + '-' + VERSION
        now_time = time(Time.now)
        @attrs = dict({
          name(:Creator) => text(app_name),
          name(:Producer) => text(app_name),
          name(:CreationDate) => now_time,
          name(:ModDate) => now_time,
name(:Author) => text('author'),
name(:Title) => text('title'),
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
        @object_header.render.concat(
          @attrs.render, LF, 'endobj', LF)
      end
    end
  end
end

