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
          '-', ::Dopp::VERSION
        )
        now_time = time(Time.now)
        attributes[kw(:Creator)] = text(app_name)
        attributes[kw(:Producer)] = text(app_name)
        attributes[kw(:CreationDate)] = now_time
        attributes[kw(:ModDate)] = now_time
      end

      # Set title.
      # @param [String] title Title.
      def title=(title)
        ::Dopp::Error.check_is_a?(title, String)
        if title.ascii_only?
          attributes[kw(:Title)] = text(title)
        else
          attributes[kw(:Title)] = utf8_to_xtext(title)
        end
      end

      # Render to String.
      # @return [String] Content.
      def render
        # Render content.
        super
      end
    end
  end
end
