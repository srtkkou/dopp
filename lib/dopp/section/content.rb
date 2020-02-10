# frozen_string_literal: true

require 'dopp/section/base'

module Dopp
  module Section
    # PDF document section "content stream".
    class Content < Base
      # Initialize.
      # @param [::Dopp::Document] doc PDF document.
      def initialize(page)
        @page = page
        super(@page.document)
        # Initialize instance variables.
        @font = nil
        @font_size = 20.0
        # TODO: Remove this section.
        @stream.concat('200 150 m 600 450 l S', LF)
      end

      # Specify font to use.
      # @param [String] name Font name.
      # @param [Hash] opts Font options.
      def use_font(name, opts = {})
        @font = @document.find_or_initialize_font(name, opts)
        @page.set_font(@font)
      end

      # Write string.
      # @param [String] string String.
      def write(string)
        @stream.concat('BT', LF)
        @stream.concat(
          kw(@font.alias).render, ' ',
          @font_size.to_s, ' Tf', LF
        )
        @stream.concat(
          text(string).render, ' Tj', LF, 'ET', LF
        )
      end

      # Render to string.
      # @return [String] Content.
      def render
        super
      end
    end
  end
end
