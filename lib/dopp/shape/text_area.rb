# frozen_string_literal: true

require 'dopp/error'
require 'dopp/type'

module Dopp
  module Shape
    # Text area.
    class TextArea
      include ::Dopp::Error
      include ::Dopp::Type

      def initialize(content, text, opts = {})
        @content = content
        @text = text
      end

      def render
        lines = []
        lines << 'q'
        lines << '0.0 0.0 0.0 RG'
        lines << '0.0 0.0 0.0 rg'
        lines << 'BT'
        lines << '12 TL'
        lines << '1 0 0 1 20 32 Tm'
        lines << '/F0 12 Tf'
        # Split lines.
        @text.each_line do |line|
          line.chomp!
          unless line.empty?
            lines << text(line).render.concat(' Tj')
          end
          lines << 'T*'
        end
        lines << 'ET'
        lines << 'Q'
        lines.join(LF)
      end
    end
  end
end
