# frozen_string_literal: true

require 'dopp/section/base'

module Dopp
  module Section
    # PDF document section "content stream".
    class Content < Base
      # Initialize.
      # @param [::Dopp::Document] doc PDF document.
      def initialize(doc)
        super(doc)
      end

      # TODO: Implement real one.
      # Render to string.
      # @return [String] Content.
      def render
        # Update attributes.
        @stream = String.new.concat(
          '200 150 m 600 450 l S', LF,
          'BT', LF,
          '/F0 36. Tf', LF,
          utf8_to_xtext('こんにちは').render + ' Tj', LF,
          'ET'
        )
        # Render content.
        super
      end
    end
  end
end
