# frozen_string_literal: true

require 'dopp'
require 'dopp/type'

module Dopp
  module Shape
    # Text area.
    class TextArea
      include ::Dopp::Error
      include ::Dopp::Type

      class << self
        def define_methods(klass)
          klass.define_method(
            :text_area,
            ->(text, opts = {}) do
              TextArea.new(self, text, opts).render
            end
          )
        end
      end

      def initialize(content, text, opts = {})
        @content = content
        @text = text
      end

      def render
        @content.stream << 'q'
        @content.stream << '0.0 0.0 0.0 RG'
        @content.stream << '0.0 0.0 0.0 rg'
        @content.stream << 'BT'
        @content.stream << '12 TL'
        @content.stream << '1 0 0 1 20 32 Tm'
        @content.stream << '/F0 12 Tf'
        # Split lines.
        @text.each_line do |line|
          line.chomp!
          unless line.empty?
            @content.stream << text(line).render.concat(' Tj')
          end
          @content.stream << 'T*'
        end
        @content.stream << 'ET'
        @content.stream << 'Q'
      end
    end
  end
end
