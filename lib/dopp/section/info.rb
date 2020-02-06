# frozen_string_literal: true

require 'dopp/error'
require 'dopp/section/base'

module Dopp
  module Section
    # PDF document section "information dictionary".
    class Info < Base
      # Initialize.
      # @param [::Dopp::Document] doc PDF document.
      def initialize(doc, attrs = {})
        super(doc)
        # Initialize attributes.
        app_name = ::Dopp::APPLICATION.dup.concat(
          '-', ::Dopp::VERSION)
        now_time = time(Time.now)
        attributes[name(:Creator)] = text(app_name)
        attributes[name(:Producer)] = text(app_name)
        attributes[name(:CreationDate)] = now_time
        attributes[name(:ModDate)] = now_time
        # Initialize instance variables.
        @title = nil
      end

      # Set title.
      # @param [String] title Title.
      def title=(title)
        ::Dopp::Error.check_is_a?(title, String)
        if title.ascii_only?
          @title = text(title)
        else
          @title = utf8_to_xtext(title)
        end
      end

      # Render to String.
      # @return [String] Content.
      def render
        # Update attributes.
        attributes[name(:Title)] = @title
        # Render content.
        super
      end
    end
  end
end
